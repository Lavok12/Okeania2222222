export function r(n1) {
    return Math.round(n1);
}
export function rand(n1, n2) {
    return Math.random()*(Math.abs(n1)+Math.abs(n2))+n1;
}

export function background(col) {
    setBlock(0, 0, disW, disH, col);
}
export function setText(text, x, y, size, color) {
    ctx.textAlign = 'center'; 
    ctx.font = size + 'px Arial';
    ctx.fillStyle = color;
    ctx.fillText(text, x, y);
}
export function setBlock(x, y, sizeX, sizeY, color) {
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.rect(disW2+x-sizeX/2, disH2-y-sizeY/2, sizeX+1, sizeY+1);
    ctx.fill();
}
export function setImage(img2, x, y, sizeX, sizeY) {
    ctx.beginPath();
    ctx.drawImage(img2, disW2+x-sizeX/2, disH2-y-sizeY/2, sizeX+1, sizeY+1);
}
export function setEps(x, y, sizeX, sizeY, color) {
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.ellipse(disW2+x, disH2-y, sizeX/2, sizeY/2, 0, 0, 2 * Math.PI);
    ctx.fill();
}
export function setLine(x1, y1, x2, y2, color, width) {
    ctx.strokeStyle = color;
    ctx.lineWidth = width;
    ctx.beginPath();
    ctx.moveTo(disW2 + x1, disH2 - y1);
    ctx.lineTo(disW2 + x2, disH2 - y2);
    ctx.stroke();
}
export function setTriangle(x1, y1, x2, y2, x3, y3, color) {
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.moveTo(disW2 + x1, disH2 - y1);
    ctx.lineTo(disW2 + x2, disH2 - y2);
    ctx.lineTo(disW2 + x3, disH2 - y3);
    ctx.closePath();
    ctx.fill();
}

export function lab() {
    let arr = new Array(21);

    for (let i = 0; i < arr.length; i++) {
        arr[i] = new Array(21);
        for (let j = 0; j < arr[0].length; j++) {
            arr[i][j] = 1;
        }
    }
    let x = 1;
    let y = 1;
    arr[x][y] = 0;
    let a;
    let c = true
    while (c) {
        a = r(rand(0,3));
        if (a == 0) {
            if (x < 19) {
                if (arr[x+2][y] == 1) {
                    arr[x+1][y] = 0;
                    arr[x+2][y] = 0;
                }
                x+=2;
            }
        } else if (a == 1) {
            if (y < 19) {
                if (arr[x][y+2] == 1) {
                    arr[x][y+1] = 0;
                    arr[x][y+2] = 0;
                }
                y+=2;
            }
        } else if (a == 2) {
            if (x > 1) {
                if (arr[x-2][y] == 1) {
                    arr[x-1][y] = 0;
                    arr[x-2][y] = 0;
                }
                x-=2;
            }
        } else if (a == 3) {
            if (y > 1) {
                if (arr[x][y-2] == 1) {
                    arr[x][y-1] = 0;
                    arr[x][y-2] = 0;
                }
                y-=2;
            }
        }
        c = false;
        for (let x1 = 1; x1 <= 19; x1+=2) {
            for (let y1 = 1; y1 <= 19; y1+=2) {
                if (arr[x1][y1] == 1) {
                    c = true;
                }
            }
        }
    }
    for (let i = 0; i < arr.length; i++) {
        for (let j = 0; j < arr[0].length; j++) {
            if (i != 0 && i != 20 && j != 0 && j != 20 ) {
                arr[i][j]*=10;
            } else {
                arr[i][j] = -1;
            }
        }
    }
    return arr;
}