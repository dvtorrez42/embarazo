-- Encuesta de nombres: cada fila es un voto (sugerir un nombre también cuenta como voto)
create table votos (
  id bigint generated always as identity primary key,
  votante text not null check (length(trim(votante)) between 1 and 60),
  nombre text not null check (length(trim(nombre)) between 1 and 40),
  creado timestamptz not null default now()
);

-- Una persona puede votar varios nombres, pero cada nombre una sola vez
create unique index votos_votante_nombre_unico on votos (lower(trim(votante)), lower(trim(nombre)));

-- El proyecto no expone tablas nuevas automáticamente: dar acceso explícito
grant select, insert on votos to anon;

alter table votos enable row level security;
create policy "leer votos" on votos for select to anon using (true);
create policy "votar" on votos for insert to anon with check (true);
