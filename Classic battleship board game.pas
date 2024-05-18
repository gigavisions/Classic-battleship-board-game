program GiGaproject;

Uses sysutils;
type
   position_array = array[integer,char] of integer; 
var
   shiptype : array [1..4] of integer; {Number of ships in each level. ship[1] is 1x1 ship. ship[2] is 1x2 ship........}
   orientation, shipCount: integer; {orientation is to know whether the ship is horizontal or vertical. shipcount mark the count of inputed ships }
   input1,input2,size : integer; {input1,input2 is for f1() and f2(). size is for the three levels of the game. easy:5, medium:10, hard:15}
   player,count: integer; {count is for number of positions occupied after placing all the ships in eash level. player can be 1 or 2}
   ship: string;  {cordinates are given through ship variable}
   player1,player2,players : position_array;
   correctguesses: array[1..2] of integer;
   playersnames : array[1..2] of string;
   
   
procedure f1(); {first menu selection}
begin
	writeln('1.Rules of the game');
	writeln('2.Play with another player');
	writeln('3.play with computer');
	writeln('4.Quit');
	writeln('Enter Your selection');
	readln(input1);
	writeln('');
end; 

procedure f2();
begin
	if input1 = 2 then
	begin
	writeln('what is the name of the first player');
	readln(playersnames[1]);
	writeln('what is the name of the second player');
	readln(playersnames[2]);
	end;
	if input1 = 3 then
	begin
	writeln('what is the name of the player');
	readln(playersnames[2]);
	playersnames[1]:='computer';
	end;
end;

procedure f3(); {difficult level selection}
begin
	writeln('1.Easy(5x5)');
	writeln('2.Medium(10x10)');
	writeln('3.Hard(15x15)');
	writeln('Enter Your selection');
	readln(input2);
	writeln('');
end; 

procedure initializations(); {intializing the arrays and variables}
var
	i : integer;
	c : char;
begin
	for i:=1 to 26 do					
		for c:= 'A' to 'Z' do
		begin
			player1[i][c]:=0;	
			player2[i][c]:=0;	
		end;
	player:=1;
	case (input2) of
	1: begin size:=5; shiptype[1]:=2; shiptype[2]:=2; shiptype[3]:=0; shiptype[4]:=0; count:=6; end;  {setting number of ships}
	2: begin size:=10; shiptype[1]:=1; shiptype[2]:=1; shiptype[3]:=2; shiptype[4]:=1; count:=13; end;
	3: begin size:=15; shiptype[1]:=2; shiptype[2]:=2; shiptype[3]:=2; shiptype[4]:=2; count:=20; end;
	end;
	correctguesses[1]:=0;
	correctguesses[2]:=0;
end;

procedure swapPlayer(); {change the player variable to 1 or 2}
begin
	if player = 1 then
		begin
		player:=2;
		exit;
		end;
	if player = 2 then
		player:=1
end;

procedure grid(j : integer); {use to make a grid and show the guessed positions}
var
	y,y1 :char;
	i :integer;
begin
	y1:='A';
	inc(y1,size-1);
	writeln('');
	writeln('');
	for y:= 'A' to y1 do write('	|   ',y);
	writeln('');
	for i:=1 to size do
	begin
	case size of
	5:writeln('--------------------------------------------------------');
	10:writeln('------------------------------------------------------------------------------------------');
	15:writeln('--------------------------------------------------------------------------------------------------------------------------------');
	end;
	write(i);
	for y:='A' to y1 do
	begin
	case j of
	1:begin
	case (player) of
	1:players:=player1;
	2:players:=player2;
	end;
	case players[i][y] of
		0:write('	|   ');
		1:write('	|   x');
	end;
	end;
	2:
	begin
	case (player) of
	1:players:=player2;
	2:players:=player1;
	end;
	case players[i][y] of
		0:write('	|   ');
		1:write('	|   ');
		2:write('	|   0');
		3:write('	|   x');
	end;
	end;
	end;
	end;
		writeln('');
		writeln('');
	end;
end;

procedure checkship(len : integer);  {Checking whether a ship can be placed and if can it is placed. len is the length of ship. for 1x1 len=1 , 1x2 len=2 ......}
var
	y1,y2,y3,y,ch : char;  {y1,y2,x1,x2 is used to check around the position. for 1x1 it checks 9 positions, for 1x2 it checks 12 positions ...........}
	x1,x2,x3,x : integer; {x3 and y3 used to check whether the given position is in correct range. with 5x5 or 10x10 or 15x15}
							{x,y use to run the loops. ch use to set the last letter of the range. for 5x5 ch is 'E'}
	
	flag : boolean;		{flag use to know whether the if statement is exicuted}				
begin
	case (player) of
	1:players:=player1;
	2:players:=player2;
	end;
	len:=len-1;
	flag := false;
	y1:=ship[3];
	y3:=y1;
	y2:=y1;
	dec(y1,1);
	inc(y2,1);
	x3:= StrToInt(ship[1]+ship[2]);
	x1:=x3;
	x2:= x1+1;
	x1:=x1-1;
	ch:='A';
	inc(ch,size-1);
	if (x3>size) or (x3<1) or (y3<'A') or (y3>ch) then
			begin
			writeln('Out of the Range');
			flag := true;
			exit;
			end;
	if (orientation=1) then 
	begin
		if (x3+len>size) then
			begin
			writeln('Out of the Range');
			flag := true;
			exit;
			end;
		x2:= x2+len;
		for y:=y1 to y2 do
		 for x:=x1 to x2 do
		 begin
			if players[x][y]=1 then
				begin
				writeln('cannot enter because of ',x,y);
				flag := true;
				break;
				end;
		end;
		if flag = false then
		begin
		y:=ship[3];
		x2:=x3+len;
		for x:=x3 to x2 do
		players[x][y]:=1;
		inc(shipCount);
		end;
	end;
	if orientation=2 then
	begin
		inc(y3,len);
		if (y3>ch) then
		begin
				writeln('Out of the Range');
				flag := true;
				exit;
		end;
		inc(y2,len);
		for y:=y1 to y2 do
		 for x:=x1 to x2 do
			begin
			if players[x][y]=1 then
				begin
				writeln('cannot enter because of ',x,y);
				flag := true;
				break;
				end;
			end;
		if flag= false then
		begin
		y1:=ship[3];
		y2:=y1;
		inc(y2,len);
		for y:=y1 to y2 do
			players[x3][y]:=1;
		inc(shipCount);
		end;
	end;
	case (player) of
	1:player1:=players;
	2:player2:=players;
	end;
end;


procedure randomship(); {generate random ship position}
var
	k: char;
	i: integer;
begin
		k:='A';
		inc(k,random(size));
		i:=random(2);
		case (size) of
		5:ship:= '0' + IntToStr(random(5)+1) + k;
		10:begin
			case (i) of
			0:ship:= '0' + IntToStr(random(8)+1) + k;
			1:ship:= '1' + '0' + k;
			end;
			end;
		15:begin
			case (i) of
			0:ship:= '0' + IntToStr(random(8)+1) + k;
			1:ship:= '1' + IntToStr(random(6)) + k;
			end;
		   end;
		end;
		orientation:=random(2)+1;
end;

procedure inputship(); {taking input position for each ship}
var
	i : integer;
begin
for i:=1 to 4 do
	begin
		shipCount:=1;
		while shipCount <= shiptype[i] do
		begin
		writeln(playersnames[player],' Enter positions of ship',shipCount,' of size 1x',i);
		readln(ship);
		orientation:=1;
		if (i=2) or (i=3) or (i=4) then
			begin
					writeln('1.verticle');
					writeln('2.horizontal');
					writeln('Enter your selection');
					readln(orientation);
			end;
				checkship(i);
				writeln('ship positions entered by ',playersnames[player]);
				grid(1);
		end;
	end;
end;

procedure guess(); {use to take guessed inputs}
var
	i: integer;
	j : char;
begin
	case (player) of
	1:players:=player2;
	2:players:=player1;
	end;
	if (player=1) and (input1=3) then
	begin
	randomship();
	writeln('');
	writeln(playersnames[player],' entered the guessed position');
	writeln(ship);
	end;
	
	if not((player=1) and (input1=3)) then
	begin
	writeln(playersnames[player],' enter the guessed position');
	readln(ship);
	end;
	i:=StrToInt(ship[1]+ship[2]);
	j:=ship[3];
	case (players[i][j]) of
	0: begin players[i][j]:=2; end;
	1: begin players[i][j]:=3; correctguesses[player]:= correctguesses[player]+1 end;
	end;
	case (player) of
	1:player2:=players;
	2:player1:=players;
	end;
	grid(2);
end;

procedure makingSpace();
var
	i:integer;
begin
	for i:=1 to 50 do
		writeln();
end;
 
procedure pvp(); {flow of player vs player}
begin
	inputship();
	makingSpace();
	swapPlayer();
	inputship();
	makingSpace();
	repeat;
	swapPlayer();
	guess();
	until correctguesses[player] = count;
	writeln(playersnames[player],' won the game');
end;

procedure cvp(); {flow of computer vs player}
var
	i : integer;
begin 
		for i:=1 to 4 do
			begin
				shipCount:=1;
				while shipCount <= shiptype[i] do
				begin
					randomship();
					checkship(i);
				end;
			end;
		swapPlayer();
		inputship();
		makingSpace;
	repeat;
	swapPlayer();
	guess();
	until correctguesses[player] = count;
	writeln(playersnames[player],' won the game');
end;

procedure htp(); {how to play}
begin
end;

begin
	randomize;
	f1();
	if input1=4 then
		exit;
		
	f2();
	
	f3();
	
	initializations();
	
	case (input1) of
	1:htp();   {How To Play}
	2:pvp();	{player vs player}
	3:cvp();	{computer vs player}
	end;
	
   
   
end.
