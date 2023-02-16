local grafana = import 'grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local prometheus_source = {
  type: 'prometheus',
  uid: "PBFA97CFB590B2093"
};

// Node 3 monitoring dashboard with load average monitoring
local node3_dashboard = grafana.dashboard.new(
    'node3_stats.json',
    description='System metrics for node3',
    tags=['node','linux']
    )
.addTemplate(
  grafana.template.datasource(
    'PROMETHEUS_DS',
    'prometheus',
    'Prometheus',
    hide='label',
  )
)
.addPanel(
  grafana.graphPanel.new(
    'Load Average',
    format='s',
    datasource=prometheus_source,
    span=2
  ).addTarget(
    prometheus.target(
      'node_load5{instance=\"node3.example.com:9100\"}',
      datasource="$PROMETHEUS_DS",
      format='time_series',
      legendFormat= "{{instance}} 5minAverage"
    )
  )
  .addTarget(
    prometheus.target(
      'node_load1{instance=\"node3.example.com:9100\"}',
      datasource="$PROMETHEUS_DS",
      format='time_series',
      legendFormat= "{{instance}} 1minAverage"
    )
  )
  .addTarget(
    prometheus.target(
      'node_load15{instance=\"node3.example.com:9100\"}',
      datasource="$PROMETHEUS_DS",
      format='time_series',
      legendFormat= "{{instance}} 15minAverage"
    )
  ),
   gridPos={
    x: 0,
    y: 0,
    w: 24,
    h: 15,
  }
);

local resource = {
  defaultApiVersion:: 'grizzly.grafana.com/v1alpha1',
  new(kind, name):: {
    apiVersion: $.defaultApiVersion,
    kind: kind,
    metadata: {
      name: name,
    },
  },
  withApiVersion(apiVersion):: {
    defaultApiVersion:: apiVersion,
    apiVersion: apiVersion,
  },
  addMetadata(name, value):: {
    metadata+: {
      [name]: value,
    },
  },
  withSpec(spec):: {
    spec: spec,
  },
};

local folder =  {
    new(name, title)::
      resource.new('DashboardFolder', name)
      + resource.withSpec({
        title: title,
      }),
  };



{
  grafanaDashboards:: {
    node3_dashboard: node3_dashboard
  },
  folders: [
    folder.new('sample', 'Sample'),
  ],
}
