local grafana = import 'grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

local prometheus_source = {
  type: 'prometheus',
  uid: "PBFA97CFB590B2093"
};

local grr = import 'jsonnet-libs/grizzly/grizzly.libsonnet';

local node3_dashboard = import 'dashboard.jsonnet';

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

local dashboar_simple = {
  title: 'Production Overview',
  tags: ['templated'],
  timezone: 'browser',
  schemaVersion: 17,
};

{
  folders: [
    folder.new('sample', 'Sample'),
  ],  
  dashboards: [
    grr.dashboard.new('node3_dashboard', node3_dashboard.new()) + grr.resource.addMetadata('folder', 'sample'),
     grr.dashboard.new('prod-overview', dashboar_simple)
    + grr.resource.addMetadata('folder', 'sample')
  ]
}
