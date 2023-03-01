{pkgs}:
pkgs.devshell.mkShell {
  name = "blog-api";

  env = [
    {
      name = "DATABASE_URL";
      value = "postgresql://todomvc_dbuser:todomvc_dbpass@localhost:5432/todomvc_db";
    }

    {
      name = "PGHOST";
      value = "localhost";
    }

    {
      name = "PGPORT";
      value = "5432";
    }

    {
      name = "PGDATABASE";
      value = "blog_api";
    }

    {
      name = "PGUSER";
      value = "blog_api";
    }

    {
      name = "PGPASSWORD";
      value = "password";
    }
  ];

  commands = [
    {
      name = "pginit";
      help = "init psql service";
      category = "database";
      command = ''
        #!${pkgs.stdenv.shell}
        pg_pid=""
        set -euo pipefail
        # TODO: explain what's happening here
        LOCAL_PGHOST=$PGHOST
        LOCAL_PGPORT=$PGPORT
        LOCAL_PGDATABASE=$PGDATABASE
        LOCAL_PGUSER=$PGUSER
        LOCAL_PGPASSWORD=$PGPASSWORD
        unset PGUSER PGPASSWORD
        initdb -D $HOME/.pgdata
        echo "unix_socket_directories = '$(mktemp -d)'" >> $HOME/.pgdata/postgresql.conf
        # TODO: port
        pg_ctl -D "$HOME/.pgdata" -w start || (echo pg_ctl failed; exit 1)
        until psql postgres -c "SELECT 1" > /dev/null 2>&1 ; do
            echo waiting for pg
            sleep 0.5
        done
        psql postgres -w -c "CREATE DATABASE $LOCAL_PGDATABASE"
        psql postgres -w -c "CREATE ROLE $LOCAL_PGUSER WITH LOGIN PASSWORD '$LOCAL_PGPASSWORD'"
        psql postgres -w -c "GRANT ALL PRIVILEGES ON DATABASE $LOCAL_PGDATABASE TO $LOCAL_PGUSER"
      '';
    }
    {
      name = "pgstart";
      help = "start psql service";
      category = "database";
      command = ''
        #!${pkgs.stdenv.shell}
            pg_pid=""
            set -euo pipefail
            # TODO: explain what's happening here
            LOCAL_PGHOST=$PGHOST
            LOCAL_PGPORT=$PGPORT
            LOCAL_PGDATABASE=$PGDATABASE
            LOCAL_PGUSER=$PGUSER
            LOCAL_PGPASSWORD=$PGPASSWORD
            unset PGUSER PGPASSWORD
            # TODO: port
            pg_ctl -D "$HOME/.pgdata" -w start || (echo pg_ctl failed; exit 1)
            until psql postgres -c "SELECT 1" > /dev/null 2>&1 ; do
                echo waiting for pg
                sleep 0.5
            done
      '';
    }
    {
      name = "pgstop";
      help = "stop psql service";
      category = "database";
      command = ''
        #!${pkgs.stdenv.shell}
        pg_pid=""
        set -euo pipefail
        pg_ctl -D $HOME/.pgdata -w -m immediate stop
      '';
    }
  ];

  packages = with pkgs; [
    air
    sqlc
    go
    pgformatter
    # database
    postgresql
  ];
}
