# Database Backup Script

Script simple para hacer backups completos de PostgreSQL, MongoDB y MySQL.

## Configuración por defecto

- **Host**: `192.168.0.110`
- **Directorio de backups**: `/mnt/storage/backups`
- **PostgreSQL**: Puerto 5432, usuario `postgres`
- **MongoDB**: Puerto 27017, sin autenticación
- **MySQL**: Puerto 3306, usuario `root`

## Uso básico

```bash
./backup_databases.sh
```

## Personalizar configuración

### Opción 1: Variables de entorno

```bash
export PG_PASSWORD="mi_password"
export MYSQL_PASSWORD="mi_password"
export MONGO_USER="mi_usuario"
export MONGO_PASSWORD="mi_password"
./backup_databases.sh
```

### Opción 2: Archivo de configuración

1. Copia el archivo de ejemplo:
```bash
cp backup_config.env.example backup_config.env
```

2. Edita `backup_config.env` con tus credenciales

3. Ejecuta el script:
```bash
source backup_config.env
./backup_databases.sh
```

## Estructura de backups

Los backups se guardan en:
```
/mnt/storage/backups/
├── postgresql/
│   └── postgresql_full_backup_YYYYMMDD_HHMMSS.sql.gz
├── mongodb/
│   └── mongodb_backup_YYYYMMDD_HHMMSS.tar.gz
└── mysql/
    └── mysql_full_backup_YYYYMMDD_HHMMSS.sql.gz
```

## Variables configurables

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `PG_HOST` | Host de PostgreSQL | 192.168.0.110 |
| `PG_PORT` | Puerto de PostgreSQL | 5432 |
| `PG_USER` | Usuario de PostgreSQL | postgres |
| `PG_PASSWORD` | Contraseña de PostgreSQL | (vacío) |
| `MONGO_HOST` | Host de MongoDB | 192.168.0.110 |
| `MONGO_PORT` | Puerto de MongoDB | 27017 |
| `MONGO_USER` | Usuario de MongoDB | (vacío) |
| `MONGO_PASSWORD` | Contraseña de MongoDB | (vacío) |
| `MYSQL_HOST` | Host de MySQL | 192.168.0.110 |
| `MYSQL_PORT` | Puerto de MySQL | 3306 |
| `MYSQL_USER` | Usuario de MySQL | root |
| `MYSQL_PASSWORD` | Contraseña de MySQL | (vacío) |
| `TARGET_DIR` | Directorio de backups | /mnt/storage/backups |

## Requisitos

- `pg_dump` y `pg_dumpall` (PostgreSQL client)
- `mongodump` (MongoDB tools)
- `mysqldump` (MySQL client)
- `gzip` y `tar` (compresión)

## Automatización con cron

Para ejecutar backups automáticos diarios a las 2:00 AM:

```bash
0 2 * * * /path/to/backup_databases.sh >> /var/log/backup.log 2>&1
```
