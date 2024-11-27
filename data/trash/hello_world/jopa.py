import sys
import io
import json
import requests
from bs4 import BeautifulSoup

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def get_page_contents(url):
    response = requests.get(url)
    return response.text

def parse_token(content):
    soup = BeautifulSoup(content, 'html.parser')
    token = soup.find('div', {"id": "public-data"})
    return token.text

def send_comment(token, referer):
    url = 'https://onlinetestpad.com/api/tests/comments'
    headers = {
        'Public-Token': token,
        'Content-Type': 'application/json',
        'Lng': 'ru',
        'Referer': referer,
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36'
    }

    data = {
        'CanEdit': 'false',
        'Children': None,
        'Comment': '\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐\n卐卐卐卐卐卐卐卐卐卐卐',
        'IsApproved': 'false',
        'Id': 0,
        'Name': 'АДОЛЬФ ГИТЛЕР',
        'ParentId': None,
        'ResultId': None,
        'RootId': None,
        'SecondsFromCreated': 0
    }
    response = requests.post(url, headers=headers, data=json.dumps(data))
    print(response.text)
    print(f'Comment sent successfully: {response.status_code == 200}')


def main():
    
    url = 'https://onlinetestpad.com/mrobglnihyx54'
    content = get_page_contents(url)
    token = parse_token(content)

    for i in range(0, 200):
        send_comment(token, url)

if __name__ == '__main__':
    main()