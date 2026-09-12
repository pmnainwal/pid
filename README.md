# P&ID Studio

A browser-based starter for drafting Piping and Instrumentation Diagrams.

## Included

- Drag-and-drop P&ID equipment and ISA-style instrument symbols
- Automatic equipment and instrument tag numbering
- Process, instrument, electrical, and utility line styles
- SVG and print-to-PDF export
- Project details panel
- Supabase schema and configuration starter for cloud authentication and project storage

## Run locally

Open `index.html` in a browser.

## Cloud setup

1. Create a Supabase project.
2. Run `supabase-schema.sql` in the Supabase SQL Editor.
3. Put your project URL and publishable key in `supabase-config.js`.

See `supabase-setup.md` for details. Never put a Supabase secret or service-role key in browser code.
