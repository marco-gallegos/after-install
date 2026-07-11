#!/usr/bin/env -S uv run --script
# /// script
# dependencies = []
# ///
import subprocess
import argparse
import sys
import json
from pathlib import Path

def get_video_streams(input_path: Path) -> list[dict]:
    cmd = [
        "ffprobe",
        "-v",
        "error",
        "-show_streams",
        "-of",
        "json",
        str(input_path),
    ]
    try:
        res = subprocess.run(cmd, capture_output=True, text=True, check=True)
        data = json.loads(res.stdout)
        return data.get("streams", [])
    except Exception as e:
        print(f"Error: Could not retrieve stream info via ffprobe: {e}")
        return []


def select_streams_interactively(input_path: Path, streams: list[dict]) -> list[str] | None:
    if not streams:
        print("No stream information found. Using default mapping.")
        return None

    print(f"\nStreams in '{input_path.name}':")
    for s in streams:
        idx = s.get("index")
        ctype = s.get("codec_type", "unknown")
        cname = s.get("codec_name", "unknown")

        # Build description
        details = []
        if ctype == "audio":
            channels = s.get("channels")
            layout = s.get("channel_layout")
            if channels:
                details.append(f"{channels}ch")
            if layout:
                details.append(layout)

        tags = s.get("tags", {})
        if tags:
            lang = tags.get("language")
            title = tags.get("title")
            if lang:
                details.append(f"lang: {lang}")
            if title:
                details.append(f'title: "{title}"')

        details_str = f" ({', '.join(details)})" if details else ""
        print(f"  [{idx}] {ctype.capitalize()}: {cname}{details_str}")

    print("\nSelect streams to keep.")
    print("Enter comma-separated indices (e.g. 0,1,2), or press Enter to keep all streams.")
    try:
        user_input = input("Selection: ").strip()
    except (KeyboardInterrupt, EOFError):
        print("\nSelection cancelled. Exiting.")
        sys.exit(1)

    if not user_input:
        return None  # Keep all streams (default mapping)

    # Parse user selection
    selected_indices = []
    available_indices = {str(s.get("index")) for s in streams}
    for item in user_input.split(","):
        item = item.strip()
        if not item:
            continue
        if item not in available_indices:
            print(f"Warning: Index '{item}' is not a valid stream index. Ignoring.")
            continue
        selected_indices.append(item)

    if not selected_indices:
        print("No valid streams selected. Using default mapping.")
        return None

    return selected_indices

PRESETS = {
    "hq": {
        "description": "High Quality: Good for archiving. Uses preset p6 and low CQ (23) for excellent details.",
        "global": ["-y", "-vsync", "0"],
        "hw_accel": ["-hwaccel", "cuda", "-hwaccel_output_format", "cuda"],
        "video": [
            "-c:v",
            "hevc_nvenc",
            "-preset",
            "p6",
            "-tune",
            "hq",
            "-rc",
            "vbr",
            "-cq:v",
            "23",
            "-b:v",
            "0",
        ],
        "audio": ["-c:a", "copy"],
    },
    "fast": {
        "description": "Fast Encoding: Prioritizes speed and lower file size. Uses preset fast and high CQ (32).",
        "global": ["-y", "-vsync", "0"],
        "hw_accel": ["-hwaccel", "cuda", "-hwaccel_output_format", "cuda"],
        "video": [
            "-c:v",
            "hevc_nvenc",
            "-preset",
            "fast",
            "-rc",
            "vbr",
            "-cq:v",
            "32",
            "-b:v",
            "0",
        ],
        "audio": ["-c:a", "copy"],
    },
    "4k": {
        "description": "4K Weight Reduction: Optimized for 4K video. Reduces file size while maintaining 4K resolution using preset p6 and CQ 28.",
        "global": ["-y", "-vsync", "0"],
        "hw_accel": ["-hwaccel", "cuda", "-hwaccel_output_format", "cuda"],
        "video": [
            "-c:v",
            "hevc_nvenc",
            "-preset",
            "p6",
            "-tune",
            "hq",
            "-rc",
            "vbr",
            "-cq:v",
            "28",
            "-b:v",
            "0",
        ],
        "audio": ["-c:a", "copy"],
    },
}

DEFAULT_PRESET = "fast"


def get_output_path(input_path: Path) -> Path:
    stem = input_path.stem
    suffix = input_path.suffix
    return input_path.parent / f"{stem}_hevc{suffix}"


def build_command(
    input_path: Path,
    output_path: Path,
    preset: dict,
    mapped_streams: list[str] = None,
    streams: list[dict] = None,
) -> list[str]:
    cmd = ["ffmpeg"]
    cmd.extend(preset["global"])
    cmd.extend(preset["hw_accel"])
    cmd.extend(["-i", str(input_path)])

    # Map selected streams if specified.
    if mapped_streams:
        for idx in mapped_streams:
            cmd.extend(["-map", f"0:{idx}"])
    else:
        # Default mapping of metadata, but let ffmpeg do default stream mapping.
        pass

    # Always copy metadata by default
    cmd.extend(["-map_metadata", "0"])

    cmd.extend(preset["video"])
    cmd.extend(preset["audio"])

    # If subtitle streams were selected, we must copy them using copy codec
    if mapped_streams and streams:
        stream_map = {str(s.get("index")): s for s in streams}
        has_subtitles = any(
            stream_map.get(idx, {}).get("codec_type") == "subtitle"
            for idx in mapped_streams
        )
        if has_subtitles:
            cmd.extend(["-c:s", "copy"])

    cmd.extend([str(output_path)])
    return cmd


def convert_file(input_path: Path, preset_slug: str, select_streams: bool) -> bool:
    if preset_slug not in PRESETS:
        print(f"Error: Unknown preset '{preset_slug}'")
        print("Available presets:")
        for name, info in PRESETS.items():
            print(f"  {name}: {info.get('description', '')}")
        return False

    if not input_path.exists():
        print(f"Error: File not found: {input_path}")
        return False

    # Get stream info
    streams = get_video_streams(input_path)

    mapped_streams = None
    if select_streams:
        mapped_streams = select_streams_interactively(input_path, streams)

    output_path = get_output_path(input_path)
    preset = PRESETS[preset_slug]
    cmd = build_command(input_path, output_path, preset, mapped_streams, streams)

    print(f"Converting: {input_path.name}")
    print(f"Output:     {output_path.name}")
    print(f"Preset:    {preset_slug}")
    print(f"Command:   {' '.join(cmd)}")
    print("-" * 40)

    result = subprocess.run(cmd)
    return result.returncode == 0


def main():
    # Build help message for presets dynamically
    preset_help_lines = ["Preset to use (default: %(default)s). Available presets:"]
    for name, info in PRESETS.items():
        preset_help_lines.append(f"  {name}: {info.get('description', '')}")
    preset_help = "\n".join(preset_help_lines)

    parser = argparse.ArgumentParser(
        description="Convert video to HEVC with NVENC",
        formatter_class=argparse.RawTextHelpFormatter,
    )
    parser.add_argument("files", nargs="+", help="Input video file(s)")
    parser.add_argument(
        "-p",
        "--preset",
        default=DEFAULT_PRESET,
        help=preset_help,
    )
    parser.add_argument(
        "-s",
        "--select",
        action="store_true",
        help="Interactively select which video and audio streams to map",
    )
    args = parser.parse_args()

    for file_path in args.files:
        input_path = Path(file_path).resolve()
        success = convert_file(input_path, args.preset, args.select)
        if not success:
            print(f"Failed: {input_path}")
            sys.exit(1)


if __name__ == "__main__":
    main()
