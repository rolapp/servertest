# servertest
small test if remote server online

Put your config file to the folder server.d.
	Filename must end with .config
	IP=<server ip>
	PORTS="80 22 .." Portnumbers seperate with space
	MAIL=<your mail address" Email address for notification when a service is not available

To protekt you from logdir overflow copy the file servertest to /etc/logrotate.d

Create a cronjob like this "*/15 * * * *     /opt/servertest/servertest.sh > /dev/null 2>&1"

log files you find in /var/log/servertest/<server-ip>
