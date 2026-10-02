#!/usr/bin/env python3
"""Shorten the sword's blade; leave the book exactly where it is.

The blade ran to x=1013 of 1024, a pixel or two from the canvas edge, so every
platform that rounds or masks the icon crowded or clipped the tip. Owner,
2026-10-03: the book must not change size or position, only the sword should
be a little shorter.

The blade is a straight bar with a long tapered tip. This cuts a 90 px
section out of the straight part (measured on the 1024 master: the blade
axis is 44.03 degrees, running through (842, 272)) and slides the tip down
the axis to close the gap, so the tip keeps its shape and the width does not
change. Pixels on the book's side of the cut are not touched at all.

Applied to the master and to the five authored colour variants (same
geometry, scaled to 512). Dark is derived from the master by
generate_brand_marks.py.

    python3 tools/shorten_blade.py            # rewrite the masters
    python3 tools/shorten_blade.py --check    # report only
"""

from __future__ import annotations

import sys
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent

# Measured on the 1024 master (principal axis of the blade pixels).
AXIS = np.array([0.71899092, -0.69501947])
ORIGIN = np.array([841.9, 272.5])
CUT_START = -90.0      # blade-axis coordinate where the removed section starts
CUT_LENGTH = 90.0      # how much shorter the blade becomes
SHORTENED_TIP = 151.0   # the tip's axis coordinate afterwards (241 - 90)

TARGETS = [ROOT / "assets" / "app_icon.png"] + [
    ROOT / "assets" / "themed_icons" / f"{name}.png"
    for name in ("Green", "Orange", "Pink", "Purple", "Red")
]


def tip_axis_coordinate(image: Image.Image) -> float:
    """Axis coordinate of the farthest non-ground pixel on the blade side."""
    rgb = np.array(image.convert("RGB")).astype(int)
    scale = image.width / 1024
    ground = rgb[2, 2]
    mask = np.abs(rgb - ground).sum(axis=2) > 40
    ys, xs = np.where(mask)
    keep = xs > 700 * scale
    points = np.c_[xs[keep], ys[keep]] / scale
    return float(((points - ORIGIN) @ AXIS).max())


def shorten(image: Image.Image) -> Image.Image:
    mode = image.mode
    rgb = image.convert("RGB")
    size = rgb.width
    s = size / 1024
    ground = tuple(int(c) for c in rgb.getpixel((2, 2)))

    shift = CUT_LENGTH * AXIS * s           # source = output + shift
    moved = rgb.transform(
        rgb.size,
        Image.AFFINE,
        (1, 0, shift[0], 0, 1, shift[1]),
        resample=Image.BICUBIC,
        fillcolor=ground,
    )

    ys, xs = np.mgrid[0:size, 0:size]
    u = ((xs + 0.5) / s - ORIGIN[0]) * AXIS[0] + ((ys + 0.5) / s - ORIGIN[1]) * AXIS[1]
    weight = np.clip((u - CUT_START) * s + 0.5, 0.0, 1.0)[..., None]   # 1 px blend

    a = np.array(rgb).astype(float)
    b = np.array(moved).astype(float)
    out = a * (1 - weight) + b * weight
    return Image.fromarray(np.clip(out + 0.5, 0, 255).astype("uint8")).convert(mode)


def main() -> int:
    check = "--check" in sys.argv
    for path in TARGETS:
        image = Image.open(path)
        tip = tip_axis_coordinate(image)
        done = tip < SHORTENED_TIP + 25
        print(f"{path.relative_to(ROOT)}: tip at axis {tip:.0f}"
              f"{' (already shortened)' if done else ''}")
        if check or done:
            continue
        shorten(image).save(path, optimize=True)
        print("  rewritten")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
