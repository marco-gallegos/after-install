#!/usr/bin/env -S uv run --script
# /// script
# dependencies = []
# ///
import subprocess
import argparse
import sys
from pathlib import Path

# TODO: metadata copy 
# TODO: multiple inputs ej 0:0 0:1

PRESETS = {
    "hq": {
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
}

DEFAULT_PRESET = "fast"


def get_output_path(input_path: Path) -> Path:
    stem = input_path.stem
    suffix = input_path.suffix
    return input_path.parent / f"{stem}_hevc{suffix}"


def build_command(input_path: Path, output_path: Path, preset: dict) -> list[str]:
    cmd = ["ffmpeg"]
    cmd.extend(preset["global"])
    cmd.extend(preset["hw_accel"])
    cmd.extend(["-i", str(input_path)])
    cmd.extend(preset["video"])
    cmd.extend(preset["audio"])
    cmd.extend([str(output_path)])
    return cmd


def convert_file(input_path: Path, preset_slug: str) -> bool:
    if preset_slug not in PRESETS:
        print(f"Error: Unknown preset '{preset_slug}'")
        print(f"Available: {', '.join(PRESETS.keys())}")
        return False

    if not input_path.exists():
        print(f"Error: File not found: {input_path}")
        return False

    output_path = get_output_path(input_path)
    preset = PRESETS[preset_slug]
    cmd = build_command(input_path, output_path, preset)

    print(f"Converting: {input_path.name}")
    print(f"Output:     {output_path.name}")
    print(f"Preset:    {preset_slug}")
    print(f"Command:   {' '.join(cmd)}")
    print("-" * 40)

    result = subprocess.run(cmd)
    return result.returncode == 0


def main():
    parser = argparse.ArgumentParser(description="Convert video to HEVC with NVENC")
    parser.add_argument("files", nargs="+", help="Input video file(s)")
    parser.add_argument(
        "-p",
        "--preset",
        default=DEFAULT_PRESET,
        help=f"Preset to use (default: {DEFAULT_PRESET})",
    )
    args = parser.parse_args()

    for file_path in args.files:
        input_path = Path(file_path).resolve()
        success = convert_file(input_path, args.preset)
        if not success:
            print(f"Failed: {input_path}")
            sys.exit(1)


if __name__ == "__main__":
    main()
