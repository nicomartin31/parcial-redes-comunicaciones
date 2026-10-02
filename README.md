# Parcial 2 – Despliegue multi-contenedor (Nginx, Joomla, PostgreSQL, Jupyter, Grafana)

## Requisitos
Docker Engine + Docker Compose v2, y el puerto 80 libre en el host.

## Arranque (3 comandos)
```bash
git clone <URL_DEL_REPOSITORIO>
cd <CARPETA_DEL_REPOSITORIO>
cp .env.example .env
docker compose up -d
```
La primera vez se construye la imagen de Jupyter y Joomla se instala solo (≈2 min).
Verifica con `docker compose ps` hasta que todos estén `healthy`.

## Accesos
| Servicio | URL | Credenciales (.env.example) |
|---|---|---|
| Joomla | http://localhost/ | – |
| Joomla admin | http://localhost/administrator | admin / Admin_Joomla_2026! |
| Grafana | http://localhost/grafana/ | admin / admin12345 |
| Jupyter | http://localhost/jupyter/?token=parcial2026 | token: parcial2026 |

## Apagar
```bash
docker compose down        # conserva datos
docker compose down -v     # borra volúmenes (reinicio limpio)
```
Documentación técnica completa en [INFORME.md](INFORME.md).