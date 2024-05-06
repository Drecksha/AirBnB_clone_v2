#!/usr/bin/python3
"""
Fabric script that creates and distributes an archive to your web servers,
using the function deploy.
"""
from fabric.api import local, env, run, put
from datetime import datetime
import os

env.hosts = ['<IP web-01>', '<IP web-02>']
env.user = 'ubuntu'  # assuming the username is ubuntu

def do_pack():
    """
    Generates a .tgz archive from the contents of the web_static folder.
    """
    try:
        if not os.path.exists("versions"):
            os.makedirs("versions")

        timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
        archive_path = "versions/web_static_{}.tgz".format(timestamp)

        local("tar -czvf {} web_static".format(archive_path))

        if os.path.exists(archive_path):
            return archive_path
        else:
            return None

    except Exception as e:
        return None

def do_deploy(archive_path):
    """
    Distributes an archive to your web servers.
    """
    if not os.path.exists(archive_path):
        return False

    try:
        archive_name = os.path.basename(archive_path)
        path_no_ext = '/data/web_static/releases/' + archive_name[:-4]
        put(archive_path, '/tmp/')
        run('mkdir -p {}'.format(path_no_ext))
        run('tar -xzf /tmp/{} -C {}'.format(archive_name, path_no_ext))
        run('rm /tmp/{}'.format(archive_name))
        run('mv {}/web_static/* {}'.format(path_no_ext, path_no_ext))
        run('rm -rf {}/web_static'.format(path_no_ext))
        run('rm -rf /data/web_static/current')
        run('ln -s {} /data/web_static/current'.format(path_no_ext))
        print("New version deployed!")
        return True
    except:
        return False

def deploy():
    """
    Packs and deploys the archive to the web servers.
    """
    archive_path = do_pack()
    if not archive_path:
        return False
    return do_deploy(archive_path)

