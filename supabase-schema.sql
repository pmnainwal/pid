-- P&ID Studio: run this once in the Supabase SQL Editor.
-- This schema keeps each user's projects private by default.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now()
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade default auth.uid(),
  name text not null default 'Untitled process diagram',
  project_number text not null default '',
  client text not null default '',
  revision text not null default 'Rev 0',
  notes text not null default '',
  diagram jsonb not null default '{"nodes":[],"pipes":[],"counters":{},"next":1}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Create the matching profile automatically whenever a user signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'display_name', new.email))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.projects enable row level security;

create policy "Users can read their own profile"
  on public.profiles for select to authenticated using (id = auth.uid());
create policy "Users can update their own profile"
  on public.profiles for update to authenticated using (id = auth.uid());
create policy "Users can create their own profile"
  on public.profiles for insert to authenticated with check (id = auth.uid());

create policy "Users can view their own projects"
  on public.projects for select to authenticated using (owner_id = auth.uid());
create policy "Users can create projects"
  on public.projects for insert to authenticated with check (owner_id = auth.uid());
create policy "Users can update their own projects"
  on public.projects for update to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
create policy "Users can delete their own projects"
  on public.projects for delete to authenticated using (owner_id = auth.uid());

create or replace function public.set_updated_at()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger projects_set_updated_at
before update on public.projects
for each row execute function public.set_updated_at();
