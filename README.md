## Laravel Queue Worker On Demand

Workers will increase by 1 every 50 queues.

### Instalation

In this case worker repo save in `/root/worker`

1. Edit **WorkingDirectory** and **ExecStart** in `worker.service`
    ```ini
    ...
    WorkingDirectory=/root/worker
    ExecStart=/root/worker/main.sh
    ...
    ```
2. Create a config in the conf directory like sample.ini
3. Move worker.service to `/etc/systemd/system`
4. Run command
    ```
    systemctl enable worker
    systemctl start worker
    ```
