/*use std::io::{self, Write};

use rand::Rng;

fn rand(n1: i32, n2: i32) -> i32 {
    return rand::thread_rng().gen_range(n1..n2);
}
fn random(n1: f32, n2: f32) -> f32 {
    return rand::thread_rng().gen_range(n1..n2);
}
fn leng3d(n1: f32, n2: f32, n3: f32) -> f32 {
    return (n1.powf(2.0)+n2.powf(2.0)+n3.powf(2.0)).sqrt();
}
fn leng(n1: f32, n2: f32) -> f32 {
    return (n1.powf(2.0)+n2.powf(2.0)).sqrt();
}
fn char_at(input: &str, id: usize) -> String {
    input.chars().nth(id).unwrap_or('!').to_string()
}

fn main() {
    let xs = 2;
    let sims = " -+)#.@";
    let mut map: [[i32; 21]; 21] = [[0; 21]; 21];

    let (mut px, mut py) = (1, 1);

    for x in 0..map.len() {
        for y in 0..map[0].len() {
            map[x][y] = 4;
        }
    }
    let (mut shx, mut shy) = (1, 1);
    map[shx][shy] = 0;
    
    let mut step = 0;
    loop {
        print!(" {}", step);
        step += 1;
        let r = rand(0, 4);
        if r == 0 {
            if shx > 1 {
                if map[shx-2][shy] == 4 {
                    map[shx-1][shy] = 0;
                    map[shx-2][shy] = 0;
                }
                shx -= 2;
            }
        } else if r == 1 {
            if shx < map.len()-2 {
                if map[shx+2][shy] == 4 {
                    map[shx+1][shy] = 0;
                    map[shx+2][shy] = 0;
                }
                shx += 2;
            }
        } else if r == 2 {
            if shy > 1 {
                if map[shx][shy-2] == 4 {
                    map[shx][shy-1] = 0;
                    map[shx][shy-2] = 0;
                }
                shy -= 2;
            }
        } else if r == 3 {
            if shy < map[0].len()-2 {
                if map[shx][shy+2] == 4 {
                    map[shx][shy+1] = 0;
                    map[shx][shy+2] = 0;
                }
                shy += 2;
            }
        }
        let mut check = true;

        if step > 10000 {
            break;
        }
    }
    loop {
        for x in 0..map.len() {
            println!(" ");
            for y in 0..map[0].len() {
                if x == px && y == py && false {
                    for i in 0..xs {
                        print!("{}", char_at(sims, 5 as usize));
                    }
                } else {
                    for i in 0..xs {
                        print!("{}", char_at(sims, map[x][y] as usize));
                    }
                }
            }
        }
        println!("");
        io::stdout().flush().unwrap();
        let mut input = String::new();
        io::stdin().read_line(&mut input).unwrap();
        let input = input.trim();

        if (input == "w") {
            px-=1;
            if map[px][py] == 4 {
                px+=1;
            }
        } else if (input == "s") {
            px+=1;
            if map[px][py] == 4 {
                px-=1;
            }
        } else if (input == "a") {
            py-=1;
            if map[px][py] == 4 {
                py+=1;
            }
        } else if (input == "d") {
            py+=1;
            if map[px][py] == 4 {
                py-=1;
            }
        }
    }
}
*/
use std::time::Instant;

fn main() {
    let start = Instant::now();
    println!("start {}", start);
    let mut x = 10.0;
    for i in 0..1000000 {
        x = (10.0).powf(10.0);
    }
    println!("end");
    let duration = start.elapsed();
    println!("Время выполнения: {} миллисекунд", duration.as_millis());
}