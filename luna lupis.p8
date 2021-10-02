pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- init

-- to do

-- make 4 bunny spawn functions
-- condensed to 1

--player
 player={}
 player.at=0
 player.coords={flr(109),flr(112)}
 player.coords2={player.coords[1],player.coords[2]}
 player.coords2home={-30,120}
 player.size={8,8}
 player.speed=0.5
 player.spr=1
 bowl={}
 bowl.coords={player.coords[1],112}
 bowl.coords2={player.coords2[1],112}
 bowl.coords2home={player.coords2home[1],player.coords2home[2]}
 bowl.width=1
 bowl.pixwidth=8
 bowl.flashspr=10
 bowl.spr=4
 
--particles
 partfreq=120
 tsincelastpart=1

--bunnies
 bunnies={}
 bunnies[1]={coords={-30,104},talksfx=47,txtcol=4,sprtalk=80,at=3,spr=64,talkspr=78,spawned=false,jmprng=10000,jmpdly=1000,jmpstart=64,jmpmid=70,jmpend=75,flipped=false,direction=-1,inix=60,iniy=95}
 bunnies[2]={coords={-30,104},talksfx=46,txtcol=8,sprtalk=144,at=3,spr=128,talkspr=78,spawned=false,jmprng=10000,jmpdly=2000,jmpstart=128,jmpmid=134,jmpend=139,flipped=false,direction=-1,inix=60,iniy=95}
 bunnies[3]={coords={-30,104},talksfx=49,txtcol=9,sprtalk=176,at=3,spr=160,talkspr=78,spawned=false,jmprng=1000,jmpdly=10,jmpstart=160,jmpmid=166,jmpend=171,flipped=false,direction=-1,inix=60,iniy=95}
 bunnies[4]={coords={-110,104},talksfx=48,txtcol=14,sprtalk=112,at=3,spr=96,talkspr=78,spawned=false,jmprng=1000,jmpdly=100,jmpstart=96,jmpmid=102,jmpend=107,flipped=false,direction=-1,inix=60,iniy=95}
 buntalksfx=47
 bunnytxtcol=4
 bunnysprtalk=80
 bunintro=false
 bunintrot=0
 
--tree
 tree={}
 tree.coords={50,88}
 tree.at={0,0,0,0}
 menuopened=false
 
--menu
 menutextcol=9
 upgrades={}
 
 upgrades.hasbowllvl1=false
 upgrades.hasbowllvl2=false
 upgrades.bowl="bowl +"
 upgrades.bowlcost=30
 
 upgrades.hasspeedlvl1=false
 upgrades.hasspeedlvl2=false
 upgrades.speed="speed +"
 upgrades.speedcost=75
 
 upgrades.hasscorelvl1=false
 upgrades.hasscorelvl2=false
 upgrades.score="score x2"
 upgrades.scorecost=150
 
 upgrades.hascure=false
 upgrades.cure="cure"
 upgrades.curecost=1000
 
 upgrades.selector={}
 upgrades.selector.coords={22,53,105,61}
 
--game
 mode="start"
 score=0
 frame=0
 tlktimer=0
 music(0)
 function _init()
-- initialise dialog system
 dtb_init()
end
-->8
-- update
function _update60()
 if mode=="game" then
  updategame()
 elseif mode=="start" then
  updatestart()
 elseif mode=="menu" then
  updatemenu()
 end
end

function updatestart()
 if btn(❎) then
  mode="game"
 end
end

function updategame()
 music(-1)
 playerbehaviour()
 petals()
 particlelogic()
 moveclouds()
 
 if btnp(❎) and player.coords[1] > 50 and player.coords[1]< 80 then
  mode="menu"
  menuopened=true
 end
 
 --spawn bunnies based on score
 if score >= 5 and bunnies[1].spawned==false then
  bunnyspawn1()
 end
 
 if score >= 15 and bunnies[2].spawned==false then
  bunnyspawn2()
 end
 
 if score >= 30 and bunnies[3].spawned==false then
  bunnyspawn3()
 end
 
 if score >= 60 and bunnies[4].spawned==false then
  bunnyspawn4()
 end
 
 bunnyjump(1)
 bunnyjump(2)
 bunnyjump(3)
 bunnyjump(4)

 dtb_update()
end

function updatemenu()

 -- free $$$$ ---
 if btnp(⬅️) then
  score+=1000
 end

 if btnp(⬇️) and 
 upgrades.selector.coords[2] < 80 then
  upgrades.selector.coords[2] = upgrades.selector.coords[2]+10
  upgrades.selector.coords[4] = upgrades.selector.coords[4]+10
 elseif btnp(⬆️) and 
 upgrades.selector.coords[2] > 53 then
  upgrades.selector.coords[2] = upgrades.selector.coords[2]-10
  upgrades.selector.coords[4] = upgrades.selector.coords[4]-10
 end
 if btnp(🅾️) and 
 upgrades.selector.coords[2] == 53 then
  if score >= upgrades.bowlcost then
   upgrades.bowl="bowl ++"
   score-=upgrades.bowlcost
   upgrades.bowlcost=100
   bowl.spr=5
   bowl.width=2
   bowl.pixwidth=15
   bowl.coords[1]-=4
   player.leftoffset=4
   player.rightoffset=124
   sfx(51)
  else
   sfx(50)
  end
 end
 if btnp(🅾️) and 
 upgrades.selector.coords[2] == 63 then
  if score > upgrades.speedcost then
   upgrades.speed="speed ++"
   score-=upgrades.speedcost
   upgrades.speedcost=150
  else
   sfx(50)
  end
 end
 if btnp(🅾️) and 
 upgrades.selector.coords[2] == 73 then
  if score > upgrades.scorecost then
   upgrades.score="score x4"
   score-=upgrades.scorecost
   upgrades.scorecost=300
  else
   sfx(50)
  end
 end
 if btnp(🅾️) and 
 upgrades.selector.coords[2] == 83 then
  if score > upgrades.curecost then
   upgrades.cure="purchased"
   score-=upgrades.curecost
   upgrades.curecost=""
  else
   sfx(50)
  end
 end
 if btnp(❎) then
  mode="game"
 end
end
-->8
-- draw
function _draw()
 if mode=="game" then
  drawgame()
 elseif mode=="start" then
  drawstart()
 elseif mode=="menu" then
  drawmenu()
 end
end

function drawstart()
 for i=0,15 do
  pal(i,i+128,1)
 end
 pal(10+128,9,1)
 pal(11+128,3+128,1)
 rectfill(0,0,128,128,0)
 circfill(64,64,40,9)
 print("\^tluna lepus",45,49,7)
 print("press ❎ to start",31,60,10)
 spr(204,tree.coords[1],tree.coords[2],4,4)
 map(0,0,0,118)
 --draw player
 spr(player.spr,player.coords[1],player.coords[2])
--draw bowl 
 spr(bowl.spr,bowl.coords[1],bowl.coords[2]-8,bowl.width,1)
end

function drawgame()
 for i=0,15 do
  pal(i+128,i,1)
 end
 rectfill(0,0,128,128,12)
--drawshuttle
 --spr(192,52,88,4,4)

--spawn bunnies
 spr(bunnies[1].jmpmid,bunnies[1].inix,bunnies[1].iniy,1,2)
 spr(bunnies[2].jmpmid,bunnies[2].inix,bunnies[2].iniy,1,2)
 spr(bunnies[3].jmpmid,bunnies[3].inix,bunnies[3].iniy,1,2)
 spr(bunnies[4].jmpmid,bunnies[4].inix,bunnies[4].iniy,1,2)

--draw tree
 spr(12,tree.coords[1],tree.coords[2],4,4)
--draw tree menu prompt
 if player.coords[1] > 50 and player.coords[1]< 80 and menuopened==false then
  print("❎",63,84,1)
 end 

--draw moon
-- spr(196,80,15,4,4)

--draw clouds 
 spr(32,cloud1coords[1],cloud1coords[2],4,2)
 spr(52,cloud2coords[1],cloud2coords[2],3,1)
 spr(36,cloud3coords[1],cloud3coords[2],1,1)

--draw bunnies
 spr(bunnies[1].spr,bunnies[1].coords[1],bunnies[1].coords[2],1,2,bunnies[1].flipped)
 spr(bunnies[2].spr,bunnies[2].coords[1],bunnies[2].coords[2],1,2,bunnies[2].flipped)
 spr(bunnies[3].spr,bunnies[3].coords[1],bunnies[3].coords[2],1,2,bunnies[3].flipped)
 spr(bunnies[4].spr,bunnies[4].coords[1],bunnies[4].coords[2],1,2,bunnies[4].flipped)
 
 
--draw player
--offscreen player
 spr(player.spr,player.coords2[1],player.coords2[2])
 spr(player.spr,player.coords[1],player.coords[2])
--draw bowl 
--offscreen bowl
 spr(bowl.spr,bowl.coords2[1],bowl.coords2[2]-8,bowl.width,1)
 spr(bowl.spr,bowl.coords[1],bowl.coords[2]-8,bowl.width,1)

 transplayer()

 dtb_draw()
  
--draw ground
 map(0,0,0,118)
--draw score
 rectfill(1,1,60,9,12)
 spr(11,2,2)
 print(score,11,3,10)
 
--draw petals
 for particle in all(particles) do
  pset(particle.x,particle.y,particle.col)
 end 
end

function drawmenu()
 rectfill(20,20,107,107,3)
 rect(20,20,107,107,7)
 line(33,26,95,26,9)
 print("★puchase upgrades★",25,29,9)
 line(33,36,95,36,9)
 print("\^iupgrade",24,45,9)
 print("\^icost",77,45,9)
 
 rectfill(upgrades.selector.coords[1],
  upgrades.selector.coords[2],
  upgrades.selector.coords[3],
  upgrades.selector.coords[4],1)
 
 print(upgrades.bowl,24,55,9)
 spr(11,77,54)
 print(upgrades.bowlcost,87,55,9)
 print(upgrades.speed,24,65,9)
 spr(11,77,64)
 print(upgrades.speedcost,87,65,9)
 print(upgrades.score,24,75,9)
 spr(11,77,74)
 print(upgrades.scorecost,87,75,9)
 print(upgrades.cure,24,85,9)
 spr(11,77,84)
 print(upgrades.curecost,87,85,9)
 
 print("buy 🅾️",23,100,9)
 print("exit ❎",78,100,9)
 
rectfill(1,1,60,9,12)
 spr(11,2,2)
 print(score,11,3,10)
end
-->8
-- player
function playerbehaviour()
--move player 
 if btn(⬅️) then
  player.at+=1
  player.coords[1]-=player.speed
  player.coords2[1]-=player.speed
  bowl.coords[1]-=player.speed
  bowl.coords2[1]-=player.speed
  if player.at==8 then
	  player.spr+=1
	  player.at=0
	 end
	 if player.spr==4 then
	  player.spr=2
	 end
	   
 elseif btn(➡️) then
  player.at+=1
  player.coords[1]+=player.speed
  player.coords2[1]+=player.speed
  bowl.coords[1]+=player.speed
  bowl.coords2[1]+=player.speed
  if player.at==8 then
   player.spr+=1
   player.at=0
  end
  if player.spr==4 then
   player.spr=2
  end
 else
  player.spr=1
 end 
end
  
--handle player wrap
function transplayer()
--while player is fully on 
--screen, keeps transition
--player off screen
if player.coords[1]>0 and player.coords[1]<128-8 then
 player.coords2[1]=-30
 bowl.coords2[1]=-30
end

--if player exits left
 if player.coords[1]==0 then
  player.coords2[1]=128
  bowl.coords2[1]=128
 end
 if player.coords[1]==-8 then
  player.coords[1]=128-8
  bowl.coords[1]=128-8
 end
 
--if player exits right
 if player.coords[1]==128-player.size[1] then
  player.coords2[1]=-8
  bowl.coords2[1]=-8
 end
 if player.coords[1]==128+player.size[1] then
  player.coords[1]=8
  bowl.coords[1]=8
 end
end
  
  
  
  
-- track time since last particle was caught
 tsincelastpart += 1
  
-- make bowl flash 
-- if tsincelastpart < 4 then
--  bowl.spr=bowl.flashspr
-- else
--  bowl.spr=4
-- end
--end


  
-->8
-- bunny behavior
-- make bunnies jump
function bunnyjump(bunny)
 bunnies[bunny].at+=1
 if bunnies[bunny].at>=rnd(bunnies[bunny].jmprng)+bunnies[bunny].jmpdly then
  bunnies[bunny].at=0
 end
 if bunnies[bunny].at==3 then
  bunnies[bunny].spr+=1
  bunnies[bunny].coords[1]+=bunnies[bunny].direction 
  bunnies[bunny].at=0
  if bunnies[bunny].spr==bunnies[bunny].jmpend then
   bunnies[bunny].spr=bunnies[bunny].jmpstart
   bunnies[bunny].at=6
  end
  if bunnies[bunny].coords[1]==5 then
   bunnies[bunny].flipped=true
   bunnies[bunny].direction=1
  elseif bunnies[bunny].coords[1]==118 then
   bunnies[bunny].flipped=false
   bunnies[bunny].direction=-1
  end
 end
end

function bunnytalking(bunny)
 buntalksfx=bunnies[bunny].talksfx
 bunnytxtcol=bunnies[bunny].txtcol
 bunnysprtalk=bunnies[bunny].sprtalk
end

function bunnyspawn1()
 if score >= 1 then
  tree.at[1] += 1
  if tree.at[1] == 1 
  or tree.at[1] == 50
  or tree.at[1] == 100
  or tree.at[1] == 115
  or tree.at[1] == 130
  or tree.at[1] == 140 then
   sfx(44)
   spawnparticle(flr(rnd(25)+55),
	  101, 
	  0,
	  rnd(0.5)+0.2,
	  3)
   tree.coords[1] = 51
  else
   tree.coords[1] = 50 
  end
  if tree.at[1] == 150 then
   sfx(45)
  end
  if tree.at[1] > 150 and tree.at[1] < 165 then
   bunnies[1].inix-=1
   bunnies[1].iniy-=0.5
  end
  if tree.at[1] > 165 then
   bunnies[1].inix-=0.5
   bunnies[1].iniy+=1
  end
  if bunnies[1].iniy > 106 then
   bunnies[1].inix=150
  end
  if tree.at[1] == 184 then
   bunnies[1].coords[1]=35
   dialoguerun()
  end
  if tree.at[1] == 186 then
   bunnies[1].spawned=true
  end
 end
end

function bunnyspawn2()
 if score >= 1 then
  tree.at[2] += 1
  if tree.at[2] == 1 
  or tree.at[2] == 50
  or tree.at[2] == 100
  or tree.at[2] == 115
  or tree.at[2] == 130
  or tree.at[2] == 140 then
   sfx(44)
   spawnparticle(flr(rnd(25)+55),
	  101, 
	  0,
	  rnd(0.5)+0.2,
	  3)
   tree.coords[1] = 51
  else
   tree.coords[1] = 50 
  end
  if tree.at[2] == 150 then
   sfx(45)
  end
  if tree.at[2] > 150 and tree.at[2] < 165 then
   bunnies[2].inix-=1
   bunnies[2].iniy-=0.5
  end
  if tree.at[2] > 165 then
   bunnies[2].inix-=0.5
   bunnies[2].iniy+=1
  end
  if bunnies[2].iniy > 106 then
   bunnies[2].inix=150
  end
  if tree.at[2] == 184 then
   bunnies[2].coords[1]=35
   dialoguerun()
  end
  if tree.at[2] == 186 then
   bunnies[2].spawned=true
  end
 end
end

function bunnyspawn3()
 if score >= 1 then
  tree.at[3] += 1
  if tree.at[3] == 1 
  or tree.at[3] == 50
  or tree.at[3] == 100
  or tree.at[3] == 115
  or tree.at[3] == 130
  or tree.at[3] == 140 then
   sfx(44)
   spawnparticle(flr(rnd(25)+55),
	  101, 
	  0,
	  rnd(0.5)+0.2,
	  3)
   tree.coords[1] = 51
  else
   tree.coords[1] = 50 
  end
  if tree.at[3] == 150 then
   sfx(45)
  end
  if tree.at[3] > 150 and tree.at[3] < 165 then
   bunnies[3].inix-=1
   bunnies[3].iniy-=0.5
  end
  if tree.at[3] > 165 then
   bunnies[3].inix-=0.5
   bunnies[3].iniy+=1
  end
  if bunnies[3].iniy > 106 then
   bunnies[3].inix=150
  end
  if tree.at[3] == 184 then
   bunnies[3].coords[1]=35
   dialoguerun()
  end
  if tree.at[3] == 186 then
   bunnies[3].spawned=true
  end
 end
end

function bunnyspawn4()
 if score >= 1 then
  tree.at[4] += 1
  if tree.at[4] == 1 
  or tree.at[4] == 50
  or tree.at[4] == 100
  or tree.at[4] == 115
  or tree.at[4] == 130
  or tree.at[4] == 140 then
   sfx(44)
   spawnparticle(flr(rnd(25)+55),
	  101, 
	  0,
	  rnd(0.5)+0.2,
	  3)
   tree.coords[1] = 51
  else
   tree.coords[1] = 50 
  end
  if tree.at[4] == 150 then
   sfx(45)
  end
  if tree.at[4] > 150 and tree.at[4] < 165 then
   bunnies[4].inix-=1
   bunnies[4].iniy-=0.5
  end
  if tree.at[4] > 165 then
   bunnies[4].inix-=0.5
   bunnies[4].iniy+=1
  end
  if bunnies[4].iniy > 106 then
   bunnies[4].inix=150
  end
  if tree.at[4] == 184 then
   bunnies[4].coords[1]=35
   dialoguerun()
  end
  if tree.at[4] == 186 then
   bunnies[4].spawned=true
  end
 end
end
  


-->8
-- dialog
-- call this before you start using dtb.
-- optional parameter is the number of lines that are displayed. default is 3.
function dtb_init(numlines)
	dtb_queu={}
	dtb_queuf={}
	dtb_numlines=3
	if numlines then
		dtb_numlines=numlines
	end
	_dtb_clean()
end

-- this will add a piece of text to the queu. the queu is processed automatically.
function dtb_disp(txt,callback)
	local lines={}
	local currline=""
	local curword=""
	local curchar=""
	local upt=function()
		if #curword+#currline>29 then
			add(lines,currline)
			currline=""
		end
		currline=currline..curword
		curword=""
	end
	for i=1,#txt do
		curchar=sub(txt,i,i)
		curword=curword..curchar
		if curchar==" " then
			upt()
		elseif #curword>28 then
			curword=curword.."-"
			upt()
		end
	end
	upt()
	if currline~="" then
		add(lines,currline)
	end
	add(dtb_queu,lines)
	if callback==nil then
		callback=0
	end
	add(dtb_queuf,callback)
end

-- functions with an underscore prefix are ment for internal use, don't worry about them.
function _dtb_clean()
	dtb_dislines={}
	for i=1,dtb_numlines do
		add(dtb_dislines,"")
	end
	dtb_curline=0
	dtb_ltime=0
end

function _dtb_nextline()
	dtb_curline+=1
	for i=1,#dtb_dislines-1 do
		dtb_dislines[i]=dtb_dislines[i+1]
	end
	dtb_dislines[#dtb_dislines]=""
	--(2)
end

function _dtb_nexttext()
	if dtb_queuf[1]~=0 then
		dtb_queuf[1]()
	end
	del(dtb_queuf,dtb_queuf[1])
	del(dtb_queu,dtb_queu[1])
	_dtb_clean()
	--sfx(2)
end

-- make sure that this function is called each update.
function dtb_update()
	if #dtb_queu>0 then
		if dtb_curline==0 then
			dtb_curline=1
		end
		local dislineslength=#dtb_dislines
		local curlines=dtb_queu[1]
		local curlinelength=#dtb_dislines[dislineslength]
		local complete=curlinelength>=#curlines[dtb_curline]
		if complete and dtb_curline>=#curlines then
			if btnp(4) then
				_dtb_nexttext()
				return
			end
		elseif dtb_curline>0 then
			dtb_ltime-=1
			if not complete then
				if dtb_ltime<=0 then
					local curchari=curlinelength+1
					local curchar=sub(curlines[dtb_curline],curchari,curchari)
					dtb_ltime=1
					if curchar~=" " then
						sfx(buntalksfx)
					end
					if curchar=="." then
						dtb_ltime=6
					end
					dtb_dislines[dislineslength]=dtb_dislines[dislineslength]..curchar
				end
				if btnp(4) then
					dtb_dislines[dislineslength]=curlines[dtb_curline]
				end
			else
				if btnp(4) then
					_dtb_nextline()
				end
			end
		end
	end
end

-- make sure to call this function everytime you draw.
function dtb_draw()
	if #dtb_queu>0 then
		local dislineslength=#dtb_dislines
		local offset=0
		if dtb_curline<dislineslength then
			offset=dislineslength-dtb_curline
		end
  
		rectfill(2,66-dislineslength*8,125,66,7)
		rect(1,41,126,67,6)
  rectfill(115,56,124,65,12)
		spr(bunnysprtalk,116,57)

		if dtb_curline>0 and #dtb_dislines[#dtb_dislines]==#dtb_queu[1][dtb_curline] then
			print("\x8e",118,39,1)
		end
		for i=1,dislineslength do
		 -- set text colour at end of this line
			print(dtb_dislines[i],4,i*8+60-(dislineslength+offset)*8,bunnytxtcol)
		end
	end
end

-- dialogue prompts are tied to
-- particle system
-- to be run in particle system
function dialoguerun()

-- introdunction dialogue promts
 if tree.at[1] == 184 then
  dtb_disp("greetings human.")
  dtb_disp("so here we are, back at the beginning",
  function() 
   bunnytalking(2)
  end)
 end
 if tree.at[2] == 184 then
  dtb_disp("*cough* hello cotton. hello human",
  function() 
   bunnytalking(1)
  end)
  dtb_disp("hey mixy. how're you feeling today?",
  function() 
   bunnytalking(2)
  end)
  dtb_disp("not so good. i wonder why.")
  dtb_disp("do you know what's caused my illness human?",
  function() 
   bunnytalking(3)
  end)
  
 end
 if tree.at[3] == 184 then
  dtb_disp("morning all.")
  dtb_disp("back here again are we?")
  dtb_disp("hopefully things'll go better than last time ey?",
  function() 
   bunnytalking(4)
  end)
 end
 if tree.at[4] == 184 then
  dtb_disp("hello all ♥")
  dtb_disp("how're you feeling mixy?",
  function()
   bunnytalking(2)
  end)
  dtb_disp("i've had better days.")
  dtb_disp("hopefully it'll just pass. however, something tells me i'm not going to see tomorrow.")
 end
 
 -- score based dialogue promts
-- if score == 10 then
--  dtb_disp("what is that thing?")
--  dtb_disp("a petal maybe?")
--  dtb_disp("collect collect collect \^imore")
--  dtb_disp("maybe it'll truely make you \^ihappy ♥")
-- end
-- if score == 15 then
--  buntalking = 14
--  dtb_disp("have you tried going and pressing ❎ at that wise old tree there?")
--  dtb_disp("legend has it the tree possesses great gifts which it willfully exchanges for knowledge.")
-- end
end

-->8
-- particles and clouds
--spawn table with individual
--particle attributes and add
--them to larger 'particles'
--table 

--create table for petals
 particles={}
--petal color selection
 pcol={2,3,4,8,10}
 
function spawnparticle (x,y,vx,vy,c)
 particle = {}
 particle.x = x
 particle.y = y
 particle.velx = vx
 particle.vely = vy
 particle.col = c
 add(particles,particle)
end

--delete from table when y>110
--change xy based on velocity
function particlelogic()
 for particle in all(particles) do
  particle.x += particle.velx
  particle.y += particle.vely
  if particle.y > 120 then
   del (particles,particle)
  end
--if particle collides with
--top of bowl
  if particle.y >= bowl.coords[2]-8
  and particle.y <= bowl.coords[2]-6
  and particle.x >= bowl.coords[1]
  and particle.x <= bowl.coords[1]+bowl.pixwidth then
   del (particles,particle)
   score += 1
   sfx(rnd(42))
   tsincelastpart=0
   partfreq=partfreq-0.5
   dialoguerun()
   if partfreq<15 then
    partfreq=15
   end   
  end
  if particle.y >= bowl.coords2[2]-8
  and particle.y <= bowl.coords2[2]-6
  and particle.x >= bowl.coords2[1]
  and particle.x <= bowl.coords2[1]+bowl.pixwidth then
   del (particles,particle)
   score += 1
   sfx(rnd(42))
   tsincelastpart=0
   partfreq=partfreq-0.5
   dialoguerun()
   if partfreq<15 then
    partfreq=15
   end
  end
 end 
end

function petals()
--petal spawn counter
--higher numbers reduce freq
 local pc = flr(rnd(partfreq))
 if pc == 1 then
--spawn at random x coord
  spawnparticle(flr(rnd(126)),
--spawn at 0 y (top)
  0,
--spawn with 0 x velocity  
  0,
--randomize y velocity
  rnd(0.7)+0.2,
--randomize colour from pcol
--table 
  pcol[flr(rnd(5))+1])
 end
end

--clouds
cloud1coords={-50,18}
cloud2coords={128,17}
cloud3coords={-50,10}

function moveclouds()
 cloud1coords[1] += 0.05
 cloud2coords[1] -= 0.03
 cloud3coords[1] += 0.07
 if cloud1coords[1] >= 160 then
  cloud1coords[1] = -50
 end
 if cloud2coords[1] <= -50 then
  cloud2coords[1] = 128
 end
 if cloud3coords[1] >= 140 then
  cloud3coords[1] = -50
 end
end
__gfx__
00000000003553000035530000355300aaaaaaaaaaaaaaaaaaaaaa99aaaaaaaaaaaaaaaaaaaaaa99777777770777770000000000000000000000000000000000
00000000003ff300003ff300003ff300a7aaaaaaaaa7aaaaaaaaa999aaaa7aaaaaaaaaaaaaaa9999777777777777777000000000000000000000000000000000
00700700003ff300003ff300003ff300aaaaaaa90aaaaaaaaaa999900aa7aaaaaaaaaaaaaa999990777777777007007000000000000000bbbbb0000000000000
00077000003333000033330000333300aaaa999900aaaaaaa999990000aaaaaaaaaaa999999999007777777770070070000000000000bbbbbbbbb00000000000
0007700000333300003333000033330009999990000999999999900000099999999999999999900007777770777077700000000000bbbbbbbbbbbbb000000000
007007000099990000999900009999000099990000000999999000000000099999999999999000000077770007777700000000000bbbbfbbbbb3bbbb00000000
000000000090090000f0090000900f0000f00f00000000f00f0000000000000000f00f000000000000f00f000707070000000000bbbbbbbbbbbbbbbbb0000000
0000000000f00f0000000f0000f0000000f05f00000000f05f0000000000000000f05f000000000000f05f00000000000000000bbbbbbbbbbbbbbbbbbb000000
000000000000000000000000444444544444444444444444000000000000000000000000000000000000000000000000000000bbbbb3bbbbbbbbbbbbbbb00000
0000000b00000000000b3000444454444444445454444444000606000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbb00000
b3bbbbb3bbbbbbbbbbbbbbbb44454544444445454444454500006000000000000000000000000000000000000000000000000bbbbbbbbbbbb3bbbbbbbbb30000
333333343b33333b333333334444544444444444444444540050a0a0006060000000000000000000000000000000000000000bbbbbbbbbbbb33bbbfbbbb30000
34444444444444434344444444444444444444444444444400a0a0a0000500000000000000000000000000000000000000000bbbfbbbbbbbbbbbbbbbbb330000
44444445444444444444444444444444444544444444444400a0a0a000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbb333000
4444444444444444454446444444444444444444444444440000000000000000000000000000000000000000000000000000bbbbbbbb3bbbbbbbbbbbb3333000
6444444444444454444444444444444444444444444444440000000000000000000000000000000000000000000000000000bbbbbbb33bbbbbbbbbbb33333000
0000000000000000000000000000000000000000000000000007700000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbb3333333000
00000000000000000000000000000000000000000000000007777700000000000000000000000000000000000000000000000bbbbbbbbbbbbbbb333333330000
000000000000000000000000000000000000000000000000077777000000000000000000000000000000000000000000000003333bbbbbbbb333333333330000
00000000000000000000000000000000000000000000077077777770000000000000000000000000000000000000000000000033333333333333333333300000
00000000000000000000000000000000007770000007777777777770000000000000000000000000000000000000000000000033333333333333333333300000
00000000000770000000000000000000077777000777776777777760000000000000000000000000000000000000000000000003333333333333333333000000
00000000077777000000000000000000077776600677666677666660000000000000000000000000000000000000000000000000033333044403333300000000
00000000777777700007700000000000666666666666666666666666000000000000000000000000000000000000000000000000000330044400330000000000
00000007777777770077777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044400000000000000
00000077777777770777777700000000000770000000000000000000000000000000000000000000000000000000000000000000000040044400000000000000
00077077777777777777777770770000007777000000000000000000000000000000000000000000000000000000000000000000000304444500000000000000
00777777777777777777777777777000007777700077700000000000000000000000000000000000000000000000000000000000000000045400000000000000
00777777777766777776677777777700077777770777770000777000000000000000000000000000000000000000000000000000000000045400000000000000
00777776666666677666666777777700077777777777777777777700000000000000000000000000000000000000000000000000000000045400000000000000
06766666666666666666666667776660066777777776676777777660000000000000000000000000000000000000000000000000000000444400000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000004444440000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400400004004000040400000404000
00000000000000000000000000000000000000000004040000040400000000000000000000000000000000000000000000400400004004000044440000444400
000000000000000000000000000000000004040000404000004040000004040000000000000000000000000000000000004004000040040000f4f40000f4f400
000000000000000000000000000404000040400004440000044400000040400000040400000000000000000000000000004444000044440000f4f40000f4f400
000000000000000000000000004040000444000014140440444404400444000000404000000404000040400000000000401441040014410000f4f40000f4f400
04040000040040000040400004440000141404404444444414144444444404400044044000404000004040000040400040444404004444000044440000444400
04040000040400000404000014140440444444444444f4444444f444444444440444044404440440004400000404000044444444444444440444444004444440
040404400444044004440440444444444444f4440444f4440444f4441414f4444444444444440444044404400404044000444400404444044444444444444444
0444444414144444141444444444f4440444f444004fff40004fff400444f4441414f444141444441414444404444444044ff440044ff4404414414444144144
1414f4444444f4444444f4440444f444004fff400400004004000040004fff400444ff404444f4444444f4441414f44404ffff4004ffff404444444444444444
4444f4444444f4440444f444004fff4004000040000000040000000400400044004ff0440444ff404444f4404444f444444ff444444ff4444f4ff4f44f4ff4f4
044fff40044fff40004fff40040000400000004000000000000000000000000000400000004ff044044fff40044fff4044000044440000444444444444455444
00404440004044400000444000000400000000040000000000000000000000000000000000400000004000040040044040000004400000040444444004444440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e00e0000e00e0000e0e00000e0e000
0000000000000000000000000000000000000000000e0e00000e0e00000000000000000000000000000000000000000000e00e0000e00e0000eeee0000eeee00
00000000000000000000000000000000000e0e0000e0e00000e0e000000e0e000000000000000000000000000000000000e00e0000e00e0000fefe0000fefe00
000000000000000000000000000e0e0000e0e0000eee00000eee000000e0e000000e0e0000000000000000000000000000eeee0000eeee0000fefe0000fefe00
00000000000000000000000000e0e0000eee00001e1e0ee0eeee0ee00eee000000e0e000000e0e0000e0e00000000000e01ee10e001ee10000fefe0000fefe00
0e0e00000e00e00000e0e0000eee00001e1e0ee0eeeeeeee1e1eeeeeeeee0ee000ee0ee000e0e00000e0e00000e0e000e0eeee0e00eeee0000fefe0000fefe00
0e0e00000e0e00000e0e00001e1e0ee0eeeeeeeeeeeefeeeeeeefeeeeeeeeeee0eee0eee0eee0ee000ee00000e0e0000eeeeeeeeeeeeeeee0eeeeee00eeeeee0
0e0e0ee00eee0ee00eee0ee0eeeeeeeeeeeefeee0eeefeee0eeefeee1e1efeeeeeeeeeeeeeee0eee0eee0ee00e0e0ee000eeee00e0eeee0eeeeeeeeeeeeeeeee
0eeeeeee1e1eeeee1e1eeeeeeeeefeee0eeefeee00efffe000efffe00eeefeee1e1efeee1e1eeeee1e1eeeee0eeeeeee0eeffee00eeffee0ee1ee1eeee1ee1ee
1e1efeeeeeeefeeeeeeefeee0eeefeee00efffe00e0000e00e0000e000efffe00eeeffe0eeeefeeeeeeefeee1e1efeee0effffe00effffe0eeeeeeeeeeeeeeee
eeeefeeeeeeefeee0eeefeee00efffe00e0000e00000000e0000000e00e000ee00eff0ee0eeeffe0eeeefee0eeeefeeeeeeffeeeeeeffeeeefeffefeefeffefe
0eefffe00eefffe000efffe00e0000e0000000e000000000000000000000000000e0000000eff0ee0eefffe00eefffe0ee0000eeee0000eeeeeeeeeeeee55eee
00e0eee000e0eee00000eee000000e000000000e0000000000000000000000000000000000e0000000e0000e00e00ee0e000000ee000000e0eeeeee00eeeeee0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700070007000700000700000007000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700700007007000070770000777700
000000000000000000000000000000000007070000070700000707000007070000000000000000000000000000000000007007000070070007e7e70007e7e700
000000000000000000000000000707000070700000707000007070000070700000070700000000000000000000000000007777000077770000e7e70000e7e700
000000000000000000000000007070000777000007770000077700000777000000707000000707000070700000000000708778070087780000e7e70000e7e700
07007000070070000070700007770000878707708787077077770770777707700077077000707000007070000070700070777707007777000077770000777700
07070000070700000707000087870770777777777777777787877777777777770777077707770770007700000707000077777777777777770777777007777770
07070770077707700777077077777777777767777777677777776777878767777777777777770777077707700707077000777700707777077777777777777777
07777777878777778787777777776777077767770777677707776777077767778787677787877777878777770777777707766770077667707787787777877877
87876777777767777777677707776777007666700076667000766670007666700777667077776777777767778787677707666670076666707777777777777777
77776777777767770777677700766670070000700700007007000070007000770076607707776670777767707777677777766777777667777e7ff7e77e7ff7e7
07766670077666700076667007000070000000700000000700000007000000000070000000766077077666700776667077000077770000777777777777755777
00707770007077700000777000000700000000070000000000000000000000000000000000700000007000070070077070000007700000070777777007777770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000009090000090900000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000090900000909000000000000000000000000000000000000000000000900900009009000090900000909000
00000000000000000000000000000000000909000999000009990000000909000000000000000000000000000000000000900900009009000099990000999900
000000000000000000000000000909000090900019910990999909900090900000090900000000000000000000000000009009000090090000e9e90000e9e900
000000000000000000000000009090000999000099999999199199990999000000909000000909000000000000000000009999000099990000e9e90000e9e900
00000000000000000000000009990000199109909999a9999999a9999999099000990990009090000090900000000000901991090019910000e9e90000e9e900
09090000090090000090900019910990999999990999a9990999a999999999990999099909990990009090000090900090999909009999000099990000999900
090900000909000009090000999999999999a999009aaa90009aaa901991a9999999999999990999009900000909000099999999999999990999999009999990
0909099009990990099909909999a9990999a99909000090090000900999a9991991a99919919999099909900909099000999900909999099999999999999999
0999999919919999199199990999a999009aaa900000000900000009009aaa900999aa909999a9991991999909999999099aa990099aa9909199991991999919
1991a9999999a9999999a999009aaa9009000090000000000000000000900099009aa0990999aa909999a9991991a99909aaaa9009aaaa909999999999999999
9999a9999999a9990999a999090000900000009000000000000000000000000000900000009aa0999999a9909999a999999aa999999aa9999e9ff9e99e9ff9e9
099aaa90099aaa90009aaa9000000900000000090000000000000000000000000000000000900000099aaa90099aaa9099000099990000999999999999955999
00909990009099900000999000000000000000000000000000000000000000000000000000000000009000090090099090000009900000090999999009999990
00000000000000000000000000000000000000000000555555551110000000000700700007007000000000000000000000000000000000000000000000000000
00000000000000055500000000000000000000000555666666665551100000000707000007070000000000000000000000000000000000000000000000000000
00000000000000576650000000000000000000055666666666666665510000000707777007070770000000000000000000000000000000000000000000000000
00000000000000576650000000000000000000566665566666556666651000000777777707777777000000000000000000000000000000000404000000000000
00000000000005766665000000000000000005666655556666555666665100008787777787876777000000000000000000000000000000400000500000000000
00000000000005766665000000000000000056776675555666675566666510007777677777776777000000000000000000000000040000040044000000000000
00000000000005766665000000000000000567666667555666667565556651007777666707766670000000000000000000000004004000040400500000000000
00000000000005766615000000000000006667666666756666666555555665100777777700707770000000000000000000000000000400004000000000000000
00000000000005766115000000000000006666666666666667666755577665100000000000000000000000000000000000000000004400004000000000400000
00000000000055766665500000000000066566666666666766666666666666510000000000000000000000000000000000000000045440004500000004005000
00000000000575766165650000000000065756666667756666666666656566510000000000000000000000000000000000000040450044004500000040000000
00000000000575766615650000000000066666666666775666556666555756510000000000000000000000000000000000000000000004404500044444500000
00000000005765766165665000000000666666555666677765566666777576650000000000000000000000000000000000000000000000504500440000000000
00000000005765766665665000000000666665566666666765666666666766650000000000000000000000000000000000000000000000544444500000050000
00000000057665766615666500000000766655555556666665566566666666650000000000000000000000000000000000004400004000544445000000000000
00000000057665766165666500000000766655556656666667765756666666650000000000000000000000000000000000000044444440044440000445500000
00000000576665766115666650000000766555556666666666666666666666650000000000000000000000000000000000000400000044044444445500000000
00000000576665766665666650000000766555556655577666666666666666650000000000000000000000000000000000000000004555444445050550000000
00000005766665766665666665000000766755555555557666667766666665650000000000000000000000000000000000000000004005544450050000000000
00000005755665775665675565000000776666655555556666675576566657650000000000000000000000000000000000000000044040044505000000000000
00000057555565755565755556500000a76666655555556666755566755576500000000000000000000000000000000000000000404000044500500500000000
00000005555555555555555555000000a77665555555556666656666655566500000000000000000000000000000000000000000000004044500000000000000
00000000077777060507777700000000a76767766577555666666666677766500000000000000000000000000000000000000004000000044500000000000000
000000000009900665009900000000000a7766666767755666666666666666000000000000000000000000000000000000000000000000045500000000000000
000000000000000605000000000000000a7676666666655555666666666666000000000000000000000000000000000000000000000000044500000000000000
0000000000000006650000000000000000a777666666677776666655566660000000000000000000000000000000000000000000000040045500000000000000
00000000000000060500000000000000000a76766666666666666677666600000000000000000000000000000000000000000000000004444500000000000000
000000000000000665000000000000000000a7776655666666666576666000000000000000000000000000000000000000000000000000045500000000000000
0000000000000006050000000000000000000a767666555566557766660000000000000000000000000000000000000000000000000000045500000000000000
00000000000000066500000000000000000000a77776666667777666600000000000000000000000000000000000000000000000000000045500000000000000
000000000000000605000000000000000000000aa777666666666660000000000000000000000000000000000000000000000000000000444500000000000000
00000000000000066500000000000000000000000aaa777777660000000000000000000000000000000000000000000000000000000004444450000000000000
__label__
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccaaacaaacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccacccacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccaaaccaacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccacccccacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccaaacaaacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccaaacaaacaaacccccaaacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccacccacacacccccacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccaaaccaacaaacccccaaacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccacccccacacacccccccacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccaaacaaacaaaccaccaaacccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7777ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77777ccc777cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7777777c77777cccc777cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc777777777777777777777ccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc6677777777667677777766cccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc666666666666666666666666ccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc2cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbfbbbbb3bbbbcccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbb3bbbbbbbbbbbbbbbccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbb3bbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbbbbb33bbbfbbbbbcccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbfbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccc3bbbbbbbbbbbbbbbbbbbbbbb3ccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccc33bbbbbb3bbbbbbbbbbbbbb33ccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccc333bbbb33bbbbbbbbbbbbb333ccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccaaaaaaaaccccccccccccccc3333bbbbbbbbbbbbbbbbb3333ccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccca7aaaaa9cccccccccccccccc333333bbbbbbbbbbb333333cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccaaaaaaa9cccccccccccccccc33333333bbbbbbb33333333cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccaaaaaaa9ccccccccccccccccc333333333333333333333ccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccaaaaa9cccccccccccccccccc333333333333333333333ccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccc9999cccccccccccccccccccc3333333333333333333cccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccfccfcccccccccccccccccccccc33333c444c33333cccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccfccfcccccccccccccccccccccccc33cc444cc33cccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccc3cc3cccccccccccccccc7cc7cccccccc444cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccc3ff3ccccccccccccccccc7c7ccccc4cc444cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccc3ff3cccccccccccccc77c7c7cccc3c44445cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccc3333ccccccccccccc7777777cccccccc454cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccc3333ccccccccccccc77767878ccccccc454cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccc9999ccccccccccccc77767777ccccccc454cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccbccccccccccccbcccccccccccccc9bc9ccccccccbccccc766677ccccbcc4444ccccccbccccccccccbccccbcccccccccccccccccccccccbccccccccccb
cbcccccbcccc3cccccccbbcccccc3ccccccfbbfccbcccccbcccc3777cbcccccbc444344cccccbbcccbcccccbccccbbcccccc3ccccccc3cccccccbbcccbcccccb
b3bbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbb3bbbbbbbbb3bbbbb3bbbbbbbbbbbbbbbbb3bbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbb3
33333334333333333b33333b333333333b33333b333333343333333333333334333333333b33333b333333343b33333b33333333333333333b33333b33333334
34444444434444444444444343444444444444433444444443444444344444444344444444444443344444444444444343444444434444444444444334444444
44444445444444444444444444444444444444444444444544444444444444454444444444444444444444454444444444444444444444444444444444444445
44444444454446444444444445444644444444444444444445444644444444444544464444444444444444444444444445444644454446444444444444444444
64444444444444444444445444444444444444546444444444444444644444444444444444444454644444444444445444444444444444444444445464444444
44444444444544444444444444454444444444444444444444444444444444444445444444454444444444444444444444444444444544444444444444454444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444

__map__
1012111211101110111110111112111023000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1314151413131515141413151314131425000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
05a200000c05500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
05fa00000e05500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
05fa00001005500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
05fa00001105500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
05fa00001305500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
05fa00001505500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
05fa00001705500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
00fa00001855500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00001a55500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00001c55500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00001d55500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00001f55500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00002155500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00002355500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00002401500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
01fa00002601500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00002801500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00002901500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00002b01500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00002d01500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00002f01500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01a700001853500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
019c00001a53500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01c700001c53500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
017900001d53500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01c800001f53500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01bb00002153500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01a600002353500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00003001500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
01fa00003201500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00003401500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00003501500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00003701500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00003901500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00003b01500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00000c75500700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
01fa00000e75500700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
01fa00001075500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00001175500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00001375500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00001575500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01fa00001775500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
47ff002009074090750c0740c07510074100750e0740e07509074090750c0740c07510074100750c0740c07509074090750c0740c07510074100750c0740c07509074090750c0740c07510074100750907409075
45ff00001851418515155141551511514115151551415515185141851515514155151151411515105141051518514185151551415515115141151515514155151851418515155141551511514115151051410515
930400003e6343c6343b63400004000043a6343c6343e634006040060400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004
5b04000018130191301b13021130261302a1302d1302d1302b130261301e130181301413012130101300e1300d1300c1300a10009100081000610003100001000010001100001000010000100001000010000100
5d040000232111f2212221120221212012320121201232011f201222011e201232012020123201242012220123201212012120123201232012320121201212012220121201212012220124201212012220123201
a405000024541275412a5412854100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501
950400003475035750347503675037750007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
500500001b0501c050190501a0501b050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9e0900001c01015010150101501000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
050800000c7720e772107721177213772157721777218772187721877218772187721877200702007020070200702007020070200702007020070200702007020070200702007020070200702007020070200702
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a029001f1f6101e6101d6101d6101d6101d6101d6101e6101f61021610226102361024610246102361022610206101e6101c6101a61019610186101861016610166101a6101a610196101a6101e6102061024610
000200002063418634006041c6241362400604186540f654006040060400604006040060400604006040060400604006040060400604006040060400604006040060400604006040060400604006040060400604
01100000185110e551255510050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501
__music__
02 2a424344
00 2b424344

