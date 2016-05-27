#!/bin/bash
# create database
<%= @sql_cli %> -u<%= @user %> -p<%= @password %> -e "create database <%= @name %>;"

# init with schema
cat /root/schema-<%= @name %> | <%= @sql_cli %> -u<%= @user %> -p<%= @password %> <%= @name %>
