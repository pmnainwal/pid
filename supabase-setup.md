# P&ID Studio cloud setup

1. Create a Supabase project.
2. In its SQL Editor, run `supabase-schema.sql`.
3. In Authentication settings, enable Email and password. Enable Google or Microsoft sign-in if required.
4. Copy the project URL and anon/publishable key into `supabase-config.js`. Do not expose the service-role key.
5. Add your deployed app URL under Authentication > URL Configuration.

The next implementation step is replacing the browser-local demo login and storage in `pid-studio.html` with Supabase Auth and the `projects` table. That requires the URL and anon/publishable key from step 4.
