"""Generate the master app icon and splash logo.

Run:  python3 tool/gen_icons.py

Outputs:
  assets/icon/app_icon.png         1024×1024 — used by flutter_launcher_icons
  assets/icon/app_icon_fg.png      1024×1024 — Android adaptive foreground
  assets/icon/splash_logo.png       512×512 — used by flutter_native_splash
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageFont


OUT_DIR = Path(__file__).resolve().parent.parent / "assets" / "icon"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def _try_font(size: int) -> ImageFont.ImageFont:
    # Search a few likely paths so this works across CI environments.
    for path in (
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
        "/Library/Fonts/Arial Bold.ttf",
    ):
        if Path(path).exists():
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def _rounded_square(size: int, radius: int, color: tuple[int, int, int, int]) -> Image.Image:
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle((0, 0, size, size), radius=radius, fill=color)
    return img


def _draw_centered_text(
    base: Image.Image, text: str, color: tuple[int, int, int, int], size_ratio: float = 0.46
) -> None:
    w, h = base.size
    font = _try_font(int(h * size_ratio))
    draw = ImageDraw.Draw(base)
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    # Compensate for font metric vertical offset.
    x = (w - tw) // 2 - bbox[0]
    y = (h - th) // 2 - bbox[1]
    draw.text((x, y), text, font=font, fill=color)


def _app_icon(size: int = 1024) -> Image.Image:
    accent = (31, 42, 68, 255)        # #1F2A44 — primary brand
    icon = _rounded_square(size, int(size * 0.22), accent)
    # Light ribbon corner
    draw = ImageDraw.Draw(icon)
    margin = int(size * 0.18)
    draw.rounded_rectangle(
        (margin, margin, size - margin, size - margin),
        radius=int(size * 0.10),
        outline=(255, 255, 255, 60),
        width=int(size * 0.012),
    )
    _draw_centered_text(icon, "CV", (255, 255, 255, 255), size_ratio=0.42)
    return icon


def _app_icon_fg(size: int = 1024) -> Image.Image:
    # Adaptive foreground: transparent background, brand text + bar.
    fg = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    accent = (31, 42, 68, 255)
    _draw_centered_text(fg, "CV", accent, size_ratio=0.40)
    return fg


def _splash_logo(size: int = 512) -> Image.Image:
    return _app_icon(size)


def main() -> None:
    icon = _app_icon()
    icon.save(OUT_DIR / "app_icon.png", format="PNG", optimize=True)

    fg = _app_icon_fg()
    fg.save(OUT_DIR / "app_icon_fg.png", format="PNG", optimize=True)

    splash = _splash_logo()
    splash.save(OUT_DIR / "splash_logo.png", format="PNG", optimize=True)

    print(f"Wrote: {OUT_DIR}/app_icon.png")
    print(f"Wrote: {OUT_DIR}/app_icon_fg.png")
    print(f"Wrote: {OUT_DIR}/splash_logo.png")


if __name__ == "__main__":
    main()
