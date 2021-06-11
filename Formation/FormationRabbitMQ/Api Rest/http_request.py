#!/usr/bin/env python
import json, requests

class http_request:

    def __init__(self):

        self.queue_name = "automation_q"
        self.exchange = "automation_x"

    def overview_request(self):

        uri = 'http://guest:guest@54.244.69.81:15672/api/overview'
        resp = requests.get(uri)
        jData = json.loads(resp.content)
        print(jData)

    def create_exchange(self):

        uri = 'http://guest:guest@54.244.69.81:15672/api/exchanges/test/{}'.format(self.exchange)
        payload = {"type":"direct","auto_delete":"false","durable":"true","internal":"false","arguments":{}}
        headers = {'Content-type': 'application/json'}
        resp = requests.put(uri, json=payload, headers=headers)
        print(resp)

    def create_queue(self):

        uri = 'http://guest:guest@54.244.69.81:15672/api/queues/test/{}'.format(self.queue_name)
        payload = {"auto_delete":"false","durable":"true","arguments":{},"node":"rabbit@ip-172-31-21-143"}
        headers = {'Content-type': 'application/json'}
        resp = requests.put(uri, json=payload, headers=headers)
        print(resp)

    def create_binding(self):

        uri = 'http://guest:guest@54.244.69.81:15672/api/bindings/test/e/{}/q/{}'.format(self.exchange, self.queue_name).strip()
        payload = {"routing_key": "automation_route", "arguments": {}}
        headers = {"Content-type": "application/json"}
        resp = requests.post(uri, json=payload, headers=headers)
        print(resp)

    def publish_to_exchange(self):

        uri = 'http://guest:guest@54.244.69.81:15672/api/exchanges/test/{}/publish'.format(self.exchange)
        payload = {"properties":{},"routing_key":"automation_route","payload":"my body","payload_encoding":"string"}
        headers = {'Content-type': 'application/json'}
        resp = requests.post(uri, json=payload, headers=headers)
        print(resp)

    def run(self):

        self.overview_request()
        self.create_exchange()
        self.create_queue()
        self.create_binding()
        self.publish_to_exchange()

if __name__ == '__main__':
    engine = http_request()
    engine.run()