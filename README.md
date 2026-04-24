# room.venture

A static website for hotel room reviews, built with [Hugo](https://gohugo.io/).

## Overview

room.venture is a static site that showcases and reviews hotel rooms. Photos are dumped into a folder, processed by an AI agent that extracts EXIF data, analyzes room quality, and generates static Markdown content pages with ratings. The final site features an interactive map of all reviewed locations.

## Tech Stack

- **Static Site Generator:** Hugo
- **Content Format:** Markdown with TOML front matter
- **EXIF Extraction:** ExifTool
- **Image Analysis:** Local AI vision model
- **Interactive Map:** Leaflet.js with OpenStreetMap tiles
- **Map Tiles (Detail Pages):** Static OpenStreetMap tile images
- **Image Storage:** Git LFS

## Workflow

1. **Dump photos** into `photos/inbox/` (room photos, bathroom photos, etc.)
2. **Run the processing pipeline** (AI agent or script):
   - Extract EXIF data (date, time, GPS coordinates, camera info) via ExifTool
   - Group photos by similar timestamps to identify photos belonging to the same room
   - Analyze each photo with a local AI vision model (style, age, luxury level, rating)
   - Generate a static OpenStreetMap tile image for each location
   - Create Hugo content pages (`content/reviews/`) with all metadata in front matter
   - Move processed photos to `static/images/reviews/`
3. **Commit** generated content and images (via Git LFS) to the repository
4. **Build** the Hugo site

## Getting Started

### Prerequisites

- [Hugo](https://gohugo.io/installation/) (extended edition recommended)
- [ExifTool](https://exiftool.org/)
- A local AI vision model (e.g., LLaVA, Ollama with vision support)
- [Git LFS](https://git-lfs.github.com/)

### Setup

```bash
git lfs install
git lfs track "*.jpg" "*.jpeg" "*.png" "*.webp"
```

### Local Development

```bash
hugo server -D
```

### Build

```bash
hugo
```

The generated site will be in the `public/` directory.

## Project Structure

```
room.venture/
├── photos/
│   └── inbox/          # Drop raw photos here for processing
├── content/
│   └── reviews/        # Generated review pages (Markdown)
├── static/
│   ├── images/
│   │   ├── reviews/    # Processed review photos
│   │   └── maps/       # Static OpenStreetMap tile images
│   ├── css/
│   └── js/
├── layouts/            # Hugo templates
├── data/
│   └── locations.json  # Aggregated location data for the homepage map
├── hugo.toml           # Hugo configuration
├── AGENTS.md           # AI agent instructions
└── README.md           # This file
```
