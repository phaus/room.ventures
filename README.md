# room.ventures

A static website for hotel room reviews, built with [Hugo](https://gohugo.io/).

## Overview

room.ventures is a static site that showcases and reviews hotel rooms. Photos are dumped into a folder, processed by an AI agent that extracts EXIF data, analyzes room quality, and generates static Markdown content pages with ratings. The final site features an interactive dark-themed map of all reviewed locations.

## Tech Stack

- **Static Site Generator:** Hugo
- **Content Format:** Markdown with TOML front matter
- **EXIF Extraction:** ExifTool
- **Image Analysis:** llama3.2-vision via Ollama
- **Interactive Map:** Leaflet.js with OpenStreetMap tiles
- **Map Tiles (Detail Pages):** Static OpenStreetMap tile images
- **Image Storage:** Git LFS
- **Container:** Docker (Hugo build + nginx)
- **CI/CD:** GitHub Actions (build to GHCR, deploy via SSH)

## Ingesting New Photos

Drop geotagged hotel room photos (JPEG) into `photos/inbox/` and run [OpenCode](https://opencode.ai) with:

```
based on the defined workflow, process all images in photos/inbox
```

The AI agent will automatically:

1. **Deduplicate** -- compute SHA-256 hashes and skip any photo already in `photos/processed_hashes.json`
2. **Extract EXIF** -- pull date, GPS coordinates, and camera info via ExifTool
3. **Group** -- cluster photos by timestamp proximity into hotel room visits
4. **Reverse-geocode** -- resolve GPS coordinates to hotel name, city, and country (prompts you if ambiguous)
5. **Analyze** -- assess each photo with llama3.2-vision for style, condition, luxury level, and cleanliness
6. **Generate rating** -- produce a composite 1-5 star rating
7. **Download map tile** -- fetch a static OpenStreetMap tile for the location
8. **Create review page** -- generate a Hugo content page in `content/reviews/` with full metadata
9. **Update map data** -- add the location to `data/locations.json` for the homepage map
10. **Move photos** -- copy processed images to `static/images/reviews/<slug>/`
11. **Update manifest** -- add new SHA-256 hashes to `photos/processed_hashes.json`

### Requirements

Photos must be JPEG files with EXIF GPS coordinates embedded (most smartphone cameras do this by default). The agent needs:

- [ExifTool](https://exiftool.org/) (installed automatically via Homebrew if missing)
- [Ollama](https://ollama.com/) with `llama3.2-vision:11b` (pulled automatically if missing)

### After Processing

Commit and push the generated files:

```bash
git add content/ data/ static/ photos/processed_hashes.json
git commit -m "Add new hotel reviews"
git push
```

The GitHub Actions pipeline will automatically build the Docker image and deploy.

## Getting Started

### Prerequisites

- [Hugo](https://gohugo.io/installation/) (extended edition recommended)
- [ExifTool](https://exiftool.org/)
- [Ollama](https://ollama.com/) with `llama3.2-vision:11b`
- [Git LFS](https://git-lfs.github.com/)
- [Docker](https://www.docker.com/) (for containerized builds)

### Setup

```bash
git lfs install
git lfs track "*.jpg" "*.jpeg" "*.png" "*.webp"
```

### Local Development

```bash
hugo server -D
```

### Docker Build

```bash
docker build -t room-venture .
docker run -p 8080:80 room-venture
```

### Production Build

```bash
hugo
```

The generated site will be in the `public/` directory.

## Project Structure

```
room.ventures/
├── photos/
│   ├── inbox/                 # Drop raw photos here for processing
│   └── processed_hashes.json  # SHA-256 manifest for duplicate detection
├── content/
│   └── reviews/               # Generated review pages (Markdown)
├── static/
│   └── images/
│       ├── reviews/           # Processed review photos
│       └── maps/              # Static OpenStreetMap tile images
├── layouts/
│   ├── _default/              # Base layout, homepage with map
│   └── reviews/               # Review list and detail templates
├── data/
│   └── locations.json         # Location data for the homepage map
├── .github/
│   └── workflows/             # Build and deploy pipelines
├── Dockerfile                 # Multi-stage build (Hugo + nginx)
├── hugo.toml                  # Hugo configuration
├── AGENTS.md                  # AI agent instructions
└── README.md
```
