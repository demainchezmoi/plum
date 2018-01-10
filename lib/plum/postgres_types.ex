Postgrex.Types.define(Plum.PostgresTypes, [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(), json: Poison)
