#!/usr/bin/env python3

import sys
import json
import requests
import configparser

CONFIG_PATH = '/etc/keepalived/hcloud.ini'
HETZNER_API_URL = 'https://api.hetzner.cloud/{}'

def hcloud_action(path, data, config):
    headers = {
        'Content-Type': "application/json",
        'Authorization': "Bearer {}".format(config['global']['Token'])
    }

    data_raw = json.dumps(data)

    return requests.post(HETZNER_API_URL.format(path), data=data_raw, headers=headers)


def change_server_aliases(server_id, network_id, alias_ips, config):
    data = {
        'network': network_id,
        'alias_ips': alias_ips
    }

    return hcloud_action(
        'v1/servers/{}/actions/change_alias_ips'.format(server_id),
        data,
        config
    )


def assign_fip(fip_id, server_id, config):
    data = {
        'server': server_id
    }

    return hcloud_action(
        'v1/floating_ips/{}/actions/assign'.format(fip_id),
        data,
        config
    )


def parse_string_list(s):
    s = s.strip(', ')
    if len(s) == 0:
        return []

    return s.split(',')


def to_int_list(string_list):
    return [int(str) for str in string_list]


def entrypoint(name, state):
    if state != 'MASTER':
        return

    config = configparser.ConfigParser()
    config.read(CONFIG_PATH)

    if name not in config:
        return

    this_server_id = config.getint('global', 'ServerID')
    network_id = config.getint(name, 'PrivateNetworkID', fallback=0)
    private_ips = parse_string_list(config.get(name, 'PrivateIPs', fallback=''))
    floating_ips = to_int_list(parse_string_list(config.get(name, 'FloatingIPs', fallback='')))
    server_ids = to_int_list(parse_string_list(config.get(name, 'ServerIDs', fallback='')))

    for fip_id in floating_ips:
        assign_fip(fip_id, this_server_id, config)

    if network_id != 0 and len(private_ips) > 0:
        for server_id in server_ids:
            change_server_aliases(server_id, network_id, private_ips if this_server_id == server_id else [], config)


if __name__ == '__main__':
    entrypoint(sys.argv[2], sys.argv[3])
