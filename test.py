import json
import requests

def parse_json(json_data):
    parsed_output = ""
    data = json.loads(json_data)

    for program in data:
        if program["offers_bounties"]:
            handle = program["handle"]
            parsed_output += f'bbrf new "{handle}"\n'
            parsed_output += f'bbrf use "{handle}"\n'

            in_scope_targets = program["targets"]["in_scope"]
            for target in in_scope_targets:
                if target["asset_type"] in ["URL", "WILDCARD"]:
                    asset_identifier = target["asset_identifier"]
                    parsed_output += f'bbrf inscope add {asset_identifier}\n'

            out_of_scope_targets = program["targets"]["out_of_scope"]
            for target in out_of_scope_targets:
                if target["asset_type"] in ["URL", "WILDCARD"]:
                    asset_identifier = target["asset_identifier"]
                    parsed_output += f'bbrf outscope add {asset_identifier}\n'

    return parsed_output

url = "https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/main/data/hackerone_data.json"
response = requests.get(url)
json_data = response.text

output = parse_json(json_data)
print(output)
