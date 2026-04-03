#!/usr/bin/env -S uv run --script
# /// script
# dependencies = [
#   "aiohttp>=3.9.0",
#   "aiodns>=3.2.0",
#   "click>=8.1.0"
# ]
# ///


"""
A script to enrich a JSON file by fetching data from URLs specified within it.

This script reads a JSON file, navigates to a specified array of objects,
fetches data from a URL in each object asynchronously, and adds the fetched
data back into the object under a new key.
"""

import asyncio
import json
import sys
from json.decoder import JSONDecodeError
from typing import Any, Dict, List, Optional

import aiohttp
import click


async def fetch_url(session: aiohttp.ClientSession, url: str) -> Dict[str, Any]:
    """
    Asynchronously fetches a single URL and returns its JSON content.

    Handles network errors and non-successful HTTP status codes gracefully by
    returning a structured error dictionary.

    Args:
        session: The aiohttp client session to use for the request.
        url: The URL to fetch.

    Returns:
        A dictionary containing the parsed JSON response or a structured error message.
    """
    if not url:
        return {"error": "URL is missing or empty"}
    try:
        async with session.get(url, timeout=30) as response:
            if 200 <= response.status < 300:
                # Use content_type=None to handle cases where the server might
                # not set the correct 'application/json' header.
                return await response.json(content_type=None)
            else:
                error_message = f"Failed to fetch data. Status: {response.status}"
                click.secho(f"Warning: {error_message} for URL {url}", fg="yellow", err=True)
                return {"error": error_message}
    except aiohttp.ClientError as e:
        error_message = f"Network or client error: {e.__class__.__name__}"
        click.secho(f"Warning: {error_message} for URL {url}", fg="yellow", err=True)
        return {"error": error_message}
    except asyncio.TimeoutError:
        error_message = "Request timed out"
        click.secho(f"Warning: {error_message} for URL {url}", fg="yellow", err=True)
        return {"error": error_message}
    except JSONDecodeError:
        error_message = "Failed to decode JSON response"
        click.secho(f"Warning: {error_message} for URL {url}", fg="yellow", err=True)
        return {"error": error_message}


def get_nested_item(data: Dict[str, Any], path: str) -> Optional[Any]:
    """
    Safely retrieves a nested item from a dictionary using dot-notation.

    Args:
        data: The dictionary to navigate.
        path: A string representing the path (e.g., 'data.records').

    Returns:
        The nested item if found, otherwise None.
    """
    keys = path.split('.')
    current_level = data
    for key in keys:
        if isinstance(current_level, dict) and key in current_level:
            current_level = current_level[key]
        else:
            return None
    return current_level


def load_json(file_path: str) -> Optional[Dict[str, Any]]:
    """
    Loads and parses a JSON file from the given path.

    Args:
        file_path: The path to the JSON file.

    Returns:
        The parsed JSON data as a dictionary, or None on error.
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except JSONDecodeError:
        click.secho(f"Error: Could not decode JSON from '{file_path}'. Check for syntax errors.", fg="red", err=True)
        return None
    # FileNotFoundError is handled by click.Path(exists=True)


def save_json(data: Dict[str, Any], file_path: str) -> None:
    """
    Saves a dictionary to a JSON file.

    Args:
        data: The dictionary to save.
        file_path: The path where the JSON file will be saved.
    """
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        click.secho(f"Successfully enriched data and saved to '{file_path}'", fg="green")
    except IOError as e:
        click.secho(f"Error: Could not write to output file '{file_path}': {e}", fg="red", err=True)


async def process_items(items: List[Dict[str, Any]], url_key: str, dest_key: str) -> None:
    """
    Orchestrates the asynchronous fetching and enrichment of items.

    Args:
        items: The list of objects to process.
        url_key: The key in each object containing the URL.
        dest_key: The new key to store the fetched data under.
    """
    async with aiohttp.ClientSession() as session:
        tasks = []
        for item in items:
            if not isinstance(item, dict):
                click.secho("Warning: Found a non-dictionary item in the target array, skipping.", fg="yellow", err=True)
                continue
            url = item.get(url_key)
            tasks.append(fetch_url(session, str(url) if url else ""))

        results = await asyncio.gather(*tasks)

        for item, result in zip(items, results):
            if isinstance(item, dict):
                item[dest_key] = result


async def run_enrichment(input_file: str, output_file: str, array_path: str, url_key: str, dest_key: str) -> None:
    """Core async logic for enriching the JSON file."""
    # 1. Load the source JSON
    data = load_json(input_file)
    if data is None:
        sys.exit(1)

    # 2. Find the target array
    items_to_process = get_nested_item(data, array_path)
    if items_to_process is None:
        click.secho(f"Error: The array path '{array_path}' was not found in the input JSON.", fg="red", err=True)
        sys.exit(1)
    if not isinstance(items_to_process, list):
        click.secho(f"Error: The item at '{array_path}' is not a list/array.", fg="red", err=True)
        sys.exit(1)

    # 3. Process the items asynchronously
    click.echo(f"Found {len(items_to_process)} items to process. Starting enrichment...")
    await process_items(items_to_process, url_key, dest_key)

    # 4. Save the enriched data
    save_json(data, output_file)


@click.command()
@click.option(
    "--input-file",
    required=True,
    type=click.Path(exists=True, dir_okay=False, readable=True),
    help="The path to the source JSON file."
)
@click.option(
    "--output-file",
    required=True,
    type=click.Path(dir_okay=False, writable=True),
    help="The path where the enriched JSON file will be saved."
)
@click.option(
    "--array-path",
    required=True,
    help="Dot-notation path to the target array (e.g., 'data.records')."
)
@click.option(
    "--url-key",
    default="url",
    show_default=True,
    help="The key in each object containing the URL."
)
@click.option(
    "--dest-key",
    default="details",
    show_default=True,
    help="The new key for storing fetched data."
)
def main(input_file: str, output_file: str, array_path: str, url_key: str, dest_key: str) -> None:
    """
    Enriches a JSON file by asynchronously fetching data from embedded URLs.
    """
    # Ensure aiodns is available for better DNS resolution performance
    try:
        import aiodns
    except ImportError:
        click.secho("Note: 'aiodns' not found. For better performance, install it with `uv pip install aiodns`.", fg="cyan", err=True)

    asyncio.run(run_enrichment(input_file, output_file, array_path, url_key, dest_key))


if __name__ == "__main__":
    main()
