CREATE SCHEMA IF NOT EXISTS monitoring;

CREATE EXTENSION IF NOT EXISTS file_fdw;
CREATE SERVER IF NOT EXISTS nginx_logs_srv FOREIGN DATA WRAPPER file_fdw;

-- Tabla "virtual": cada SELECT lee el archivo access_csv.log generado por Nginx
CREATE FOREIGN TABLE monitoring.nginx_access_raw (
    ts           text,
    client_ip    text,
    method       text,
    uri          text,
    status       text,
    bytes_sent   text,
    request_time text,
    host         text
) SERVER nginx_logs_srv
  OPTIONS (filename '/var/log/nginx/access_csv.log',
           format 'csv', delimiter E'\t', quote E'\x01');

CREATE OR REPLACE VIEW monitoring.v_access_logs AS
SELECT
    ts::timestamptz        AS ts,
    client_ip,
    method,
    uri,
    status::int            AS status,
    CASE WHEN status LIKE '2%' THEN '2xx'
         WHEN status LIKE '3%' THEN '3xx'
         WHEN status LIKE '4%' THEN '4xx'
         WHEN status LIKE '5%' THEN '5xx'
         ELSE 'otro' END   AS status_class,
    bytes_sent::bigint     AS bytes_sent,
    request_time::numeric  AS request_time,
    CASE WHEN uri LIKE '/jupyter%'       THEN 'jupyter'
         WHEN uri LIKE '/grafana%'       THEN 'grafana'
         WHEN uri LIKE '/administrator%' THEN 'joomla-admin'
         ELSE 'joomla' END AS service
FROM monitoring.nginx_access_raw;