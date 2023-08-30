//
//  main.swift
//  BaekJoon#2573
//
//  Created by 김병엽 on 2023/08/29.
//
// Reference: https://velog.io/@aurora_97/백준-2573번-빙산-Swift-nc9816c3

struct Point {
    let x: Int
    let y: Int
}
//상하좌우 방향
let dx = [0,0,1,-1]
let dy = [1,-1,0,0]

let t = readLine()!.split(separator: " ").map{Int(String($0))!}
let (n,m) = (t[0],t[1])

var graph = [[Int]]()
var iceList = [Point]()

for i in 0..<n {
    let t = readLine()!.split(separator: " ").map{Int(String($0))!}
    for j in 0..<m {
        if t[j] != 0 {
            iceList.append(Point(x: i, y: j))
        }
    }
    graph.append(t)
}
//덩어리 개수를 확인하는 함수
func bfs() -> Bool {
    var visit = Array(repeating: Array(repeating: false, count: m), count: n)
    visit[iceList.first!.x][iceList.first!.y] = true
    
    var queue = [iceList.first!]
    var idx = 0
    
    while queue.count > idx {
        let cur = queue[idx]
        idx += 1
        
        for i in 0..<4 {
            let nx = cur.x + dx[i]
            let ny = cur.y + dy[i]
            
            if (0..<n).contains(nx) && (0..<m).contains(ny) && !visit[nx][ny] && graph[nx][ny] != 0 {
                visit[nx][ny] = true
                queue.append(Point(x: nx, y: ny))
            }
        }
    }
    
    return visit.flatMap{$0}.filter{$0}.count == iceList.count
}

//얼음을 녹이는 함수
func meltingIce() {
    let tempIceList = iceList
    var removeList = [Int]()
    
    //각 얼음의 상하좌우를 확인하며 녹여야할 개수를 동시에 removeList에 저장
    for p in iceList {
        var numberOfZero = 0
        for i in 0..<4 {
            let nx = p.x + dx[i]
            let ny = p.y + dy[i]
            
            if (0..<n).contains(nx) && (0..<m).contains(ny) && graph[nx][ny] == 0 {
                numberOfZero += 1
            }
        }
        removeList.append(numberOfZero)
    }

    iceList.removeAll()
    for (p,cnt) in zip(tempIceList, removeList) {
        graph[p.x][p.y] -= cnt
        if graph[p.x][p.y] <= 0 {
            graph[p.x][p.y] = 0
        } else {
            iceList.append(p)
        }
    }
}

var time = 0

while true {
    time += 1
    //빙산이 줄어든다
    meltingIce()
    print(graph)
    print(iceList)
    if iceList.isEmpty {
        time = 0
        break
    }
    //덩어리 개수를 확인 (덩어리가 두개 이상이면 break)
    if !bfs() {break}
}

print(time)



