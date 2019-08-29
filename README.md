Sensu Plugins Azure Burstable Metrics
=====================================

[![Build Status](https://travis-ci.com/ElvenSpellmaker/sensu-plugins-azure-burstable-metrics.svg?branch=master)](https://travis-ci.com/ElvenSpellmaker/sensu-plugins-azure-burstable-metrics) [![Gem Version](https://badge.fury.io/rb/sensu-plugins-azure-burstable-metrics.svg)](https://badge.fury.io/rb/sensu-plugins-azure-burstable-metrics)

This is a hacky Sensu plug-in to call out to the `az` to list all vms in a
subscription and then gather metrics about burstable credits and output them in
a Graphite way.

The gem assumes `virualenv`, `python` and `pip` are installed, and will run
`install.bash` as a pre-gem hook to install a virualenv and the required `az`
command. Ick.

Tested on Ruby 2.3.

The unit test is a bit dubious, and it's almost impossible to run unit tests on
Sensu plug-ins as they run as soon as scoped...
The test must be run from the root directory also.

`bundle exec rspec` should run the test, after bundle installing of course.

Why call out to `az` instead of using the Ruby SDK?
---------------------------------------------------
There's very little documentation and this was the path of least resistance.

I'm open to re-writes which use the Ruby Gems instead. You'll need the
`azure_mgmt_compute` and `azure_mgmt_monitor` gems.
