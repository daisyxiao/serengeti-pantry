# VMware Serengeti Cookbooks and Roles

This repository contains all the cookbooks and roles used in VMware Serengeti Project.

All cookbooks and roles are created/modified by VMware Serengeti Project based on cookbooks and roles open sourced by [Infochimps](https://github.com/infochimps-labs/ironfan-pantry).

To understand the basic concept of Cookbooks and Roles (defined by Chef), please read [Chef Wiki](http://wiki.opscode.com/display/chef/Home) first.

## Main Changes in VMware Serengeti Cookbooks

* Add support for deploying a Hadoop cluster using various Hadoop Distributions (e.g. Apache Hadoop, GreenPlum HD, Cloudera CDH, Hortonworks, etc.).
* The cookbooks are targeted for deploying a Hadoop 0.20 or 1.0 cluster with support for HDFS, MapReduce, Pig and Hive.
* The cookbooks now only run well on a VM or server with RHEL 5.x and CentOS 5.x installed.

Note: Hadoop 0.23 is not supported yet.

## Roles

We mainly define the following roles for deploying a Hadoop cluster via Chef.

* hadoop : basic role applied to all nodes in a Hadoop cluster.
* hadoop_namenode    : run Hadoop NameNode service in a cluster node
* hadoop_jobtracker  : run Hadoop JobTracker service in a cluster node
* hadoop_datanode    : run Hadoop DataNode service in one or more cluster nodes
* hadoop_tasktracker : run Hadoop TaskTracker service in one or more cluster nodes
* hive : install Hive package in a cluster node
* pig  : install Pig package in a cluster node
* hadoop_client : create a node running as a client to submit MapReduce/Pig/Hive jobs to the cluster

Each role points to recipes contained in several cookbooks.

## Cookbooks and Recipes

We mainly create the following cookbooks and recipes for deploying a Hadoop cluster via Chef.

* cluster_service_discovery : runtime Hadoop services discovery (e.g. tell all nodes in a cluster what's the ip of the Hadoop NameNode)
* hadoop_cluster : contain following recipes for installing Hadoop package and running Hadoop services
   * namenode
   * jobtracker
   * datanode
   * tasktracker
   * etc.
* pig  : install Pig package
* hive : install Hive package
* install_from : install a package from a tarball

## Support for Multi Hadoop Distributions

The support for Multi Hadoop Distribution is a big exciting feature we add into VMware Serengeti Cookbooks.

In order to support multi Hadoop distributions, we choose to install Hadoop/Pig/Hive packages from the tarball
provided by Hadoop distributors. Because the folder structure of Hadoop binary tarballs and the way to start 
the Hadoop NameNode/JobTracker/DataNode/TaskTracker service in various Hadoop distributions are almost the same,
we can easily support various Hadoop distributions with minimum changes.

### Specify a Hadoop Distribution to Deploy

The meta data of a Hadoop distribution is saved into Chef databag 'hadoop_distros' before running the cookbooks.
Here is an example of databag containing the meta data of Apache Hadoop distribution:
<pre>
  $ knife data bag show hadoop_distros apache
  id:      apache  (the name of this Hadoop distribution)
  hadoop:  http://localhost/distros/apache/1.0.1/hadoop-1.0.1.tar.gz  (the url of hadoop tarball of this Hadoop distribution)
  hive:    http://localhost/distros/apache/1.0.1/hive-0.8.1.tar.gz    (the url of hive tarball of this Hadoop distribution)
  pig:     http://localhost/distros/apache/1.0.1/pig-0.9.2.tar.gz     (the url of pig tarball of this Hadoop distribution)
</pre>
You can manually save meta data for a new Hadoop Distribution with id 'new_distro' into the databag 'hadoop_distros',
add the following code in cluster role file, and upload the cluster role to Chef Server, then run the cookbooks.
<pre>
  override_attributes({
    :hadoop => {
      :distro_name => "new_distro"
    }
  })
</pre>
When VMware Serengeti Cookbooks is used by VMware Serengeti Ironfan to deploy a Hadoop cluster, the meta data of a Hadoop distribution is
specified in cluster definition file. Ironfan will read the meta data and save to databags automatically. Please read VMware Serengeti Ironfan
user guide to find out how to use it.

### Tested Hadoop Distributions

We have tested that VMware Serengeti Cookbooks can be used to successfully deploy a Hadoop cluster with the following Hadoop distributions:

* [Apache Hadoop 1.0.1](http://newverhost.com/pub/hadoop/common/hadoop-1.0.1/), [Apache Pig 0.9.2](http://www.us.apache.org/dist/pig/pig-0.9.2/) and [Apache Hive 0.8.1](http://www.us.apache.org/dist/hive/hive-0.8.1/)
* [GreenPlum HD 1.1](http://www.greenplum.com/products/greenplum-hd) which includes Hadoop 1.0.0, Hive 0.7.1 and Pig 0.9.1
* [Cloudera CDH3u3](http://archive.cloudera.com/cdh/3/hadoop-0.20.2-cdh3u3/) which includes Hadoop 0.20.2, Hive 0.7.1 and Pig 0.8.1
* [Hortonworks HDP 1.0.7](http://public-repo-1.hortonworks.com/HDP-1.0.7/repos/centos5/tars/hadoop-1.0.2.tar.gz) which includes Hadoop 1.0.2, Hive 0.8.1 and Pig 0.9.2

Other Hadoop 0.20 or 1.0 series distributions should also work well but not tested.
Please let us know if other Hadoop/Pig/Hive combination works in your environment.

# Contact

Please send email to our mailing lists for [developers](https://groups.google.com/group/serengeti-dev) or for [users](https://groups.google.com/group/serengeti-user) if you have any questions.
