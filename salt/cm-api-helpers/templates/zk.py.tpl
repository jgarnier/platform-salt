from cm_api.api_client import ApiResource


def connect_cm():
    api = ApiResource('{{ cm_host }}', username='{{ cm_user }}', password='{{ cm_pass }}')
    return api

def zookeeper_quorum():
    """ Return list of ZK quorum """
    api = connect_cm()
    cluster_name = api.get_all_clusters()[0].name
    cluster = api.get_cluster(cluster_name)
    zk_quorum = []
    for service in cluster.get_all_services():
        if service.type == "ZOOKEEPER":
            for role in service.get_all_roles():
                if role.type == "SERVER":
                    zk_quorum.append('%s' % api.get_host(role.hostRef.hostId).ipAddress + ':2181')
    return ",".join(zk_quorum)

def main():
    print zookeeper_quorum()

if __name__ == "__main__":
    main()