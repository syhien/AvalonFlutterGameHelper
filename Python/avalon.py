from datetime import date
from flask import Flask
from flask import request
from flask import jsonify
import random

def handleCORS(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response

avalon = Flask(__name__)
avalon.after_request(handleCORS)

@avalon.route('/', methods=['GET'])
def getIdentityForm():
    return '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">' + '''<form action="/" method="post">
    <p>输入本次游戏总人数(1~10)Input the number of PLAYERS:<input name="PlayersNumber"></p>
    <p>输入刚刚共同决定的本次游戏的数字Input the GAME NUMBER we just decided together:<input name="GameNumber"></p>
    <p>输入座位号(从1开始计数)Input your own SEAT NUMBER:<input name="SeatNumber"></p>
    <p><button type="submit">获取身份Get Identity</button></p>
    </form>
    '''

@avalon.route('/', methods=['POST'])
def getIdentity():
    playersNumber = int(request.form['PlayersNumber'])
    gameNumber = int(request.form['GameNumber'])
    seatNumber = int(request.form['SeatNumber'])

    identitiesMap = {
        5:['Merlin', 'Percival', 'Loyal Servant of Arthur', 'Morgana', 'Assassin'],
        6:['Merlin', 'Percival', 'Loyal Servant of Arthur', 'Morgana', 'Assassin', 'Loyal Servant of Arthur'],
        7:['Merlin', 'Percival', 'Loyal Servant of Arthur', 'Morgana', 'Assassin', 'Loyal Servant of Arthur', 'Oberon'],
        8:['Merlin', 'Percival', 'Loyal Servant of Arthur', 'Morgana', 'Assassin', 'Loyal Servant of Arthur', 'Loyal Servant of Arthur', 'Minion of Mordred'],
        9:['Merlin', 'Percival', 'Loyal Servant of Arthur', 'Morgana', 'Assassin', 'Loyal Servant of Arthur', 'Loyal Servant of Arthur', 'Loyal Servant of Arthur', 'Mordred'],
        10:['Merlin', 'Percival', 'Loyal Servant of Arthur', 'Morgana', 'Assassin', 'Loyal Servant of Arthur', 'Loyal Servant of Arthur', 'Loyal Servant of Arthur', 'Mordred', 'Oberon']
        }
    identities = identitiesMap[playersNumber]

    random.seed(gameNumber + date.today().toordinal())
    random.shuffle(identities)
    ret = {'identity': identities[int(seatNumber) - 1]}

    if identities[int(seatNumber) - 1] == 'Merlin':
        seenPlayers = []
        for i in range(len(identities)):
            if identities[i] in ['Morgana', 'Assassin', 'Oberon']:
                seenPlayers.append(i + 1)
        ret['seenPlayers'] = seenPlayers
    elif identities[int(seatNumber) - 1] == 'Percival':
        seenPlayers = []
        for i in range(len(identities)):
            if identities[i] in ['Merlin', 'Morgana']:
                seenPlayers.append(i + 1)
        ret['seenPlayers'] = seenPlayers
    elif identities[int(seatNumber) - 1] == 'Morgana':
        seenPlayers = []
        for i in range(len(identities)):
            if identities[i] in ['Assassin', 'Mordred']:
                seenPlayers.append(i + 1)
        ret['seenPlayers'] = seenPlayers
    elif identities[int(seatNumber) - 1] == 'Assassin':
        seenPlayers = []
        for i in range(len(identities)):
            if identities[i] in ['Morgana', 'Mordred']:
                seenPlayers.append(i + 1)
        ret['seenPlayers'] = seenPlayers
    elif identities[int(seatNumber) - 1] == 'Mordred':
        seenPlayers = []
        for i in range(len(identities)):
            if identities[i] in ['Morgana', 'Assassin']:
                seenPlayers.append(i + 1)
        ret['seenPlayers'] = seenPlayers
    else:
        ret['seenPlayers'] = []
    return jsonify(ret)

if __name__ == '__main__':
    avalon.run(host='0.0.0.0', port=5001, debug=True)
    