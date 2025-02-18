import sys

from ibridges.interactive import interactive_auth
from ibridges import IrodsPath
import tomllib


if __name__ == "__main__":
    irods_path_str = sys.argv[1]
    toml_path = sys.argv[2]

    with interactive_auth() as session:
        ipath = IrodsPath(session, irods_path_str)
        imeta = ipath.meta
        imeta.clear()
        with open(toml_path, "rb") as handle:
            toml_data = tomllib.load(handle)

        global_meta = toml_data["global"]
        for key, value in global_meta.items():
            if isinstance(value, list):
                imeta.add("mdg:"+key, str(value[0]), str(value[1]))
            else:
                imeta.add("mdg:"+key, str(value))
