# grafana_grafonnet
Imlementation of Grafana with Grafonnet made dashboards
This examply imply that there is a Grafana setted up locally, a Prometheus at host node2.example.com 
and prometheus node_exporter at node3.example.com to monitor node3

There 3 approaches used to deploy node3_stats dashboard.
#### Classic
From the file in directory config/provisioning/dashboards/Servers/node3_stats.json
with a script config/provision_grafana.sh . This will create a "node3_stats" dashboard in the Grafana folder "Servers"
    
    $ sudo config/provision_grafana.sh

#### Jsonnet cli
Uses dashboard-jsonnetcli.jsonnet file to generate a json with jsonnet cli, which is then placed in the propper place and a classic provision approach appy. dashboard-jsonnetcli.jsonnet import a dashboard from dashboard.jsonnet, this file is used for both jsonnet cli and grizzly cli.

Install jsonnet https://github.com/google/jsonnet#packages

    $ git clone https://github.com/grafana/grafonnet-lib.git
    $ jsonnet -J grafonnet-lib dashboard-new.jsonnet > config/provisioning/dashboards/node3_stats.json
    $ sudo config/provision_grafana.sh
This will create a "node3_stats" dashboard in a "General" folder

#### Grizzly cli
Uses Grizzly cli tool to upload a "node3_stats" dashboard into a "Sample" folder in grafana.

Install jsonnet https://github.com/google/jsonnet#packages

    $ git clone https://github.com/grafana/grafonnet-lib.git
    $ git clone https://github.com/grafana/jsonnet-libs.git
    $ grr show dashboard-grr.jsonnet 
    $ grr apply dashboard-grr.jsonnet