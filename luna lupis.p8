pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--init function


function _init()

player={}
 player.at=0
 player.coords={flr(109),flr(112)}
 player.size={8,8}
 player.speed=1
 player.spr=1
 player.hasbowl1=true
 player.hasbowl2=false
 player.hasbowl3=false
 bowl={}
 bowl.coords={player.coords[1],112}
 bowl.size={8,8}
 bowl.spr=4
--particle frequency
 partfreq=25
 tsincelastpart=1
--dialog bool
-- playdialog=false
--bunny variables
 bunnies={}
 bunnies[1]={coords={12,104},currentdialog=2,at=3,spr=64,talkspr=78,jmprng=10000,jmpdly=1000,jmpstart=64,jmpend=75,flipped=true,direction=1}
 bunnies[2]={coords={44,104},currentdialog=2,at=3,spr=128,talkspr=78,jmprng=10000,jmpdly=2000,jmpstart=128,jmpend=139,flipped=false,direction=-1}
 bunnies[3]={coords={80,104},currentdialog=2,at=3,spr=160,talkspr=78,jmprng=1000,jmpdly=10,jmpstart=160,jmpend=171,flipped=false,direction=-1}
 bunnies[4]={coords={110,104},currentdialog=2,at=3,spr=96,talkspr=78,jmprng=1000,jmpdly=100,jmpstart=96,jmpend=107,flipped=false,direction=-1}

--game variables
 score=0
 frame=0
 
-- function introtext()
 	dialog:queue("this is test text",true)
  dialog:queue("hello, friend...",true)
  dialog:queue("it's good to see you",true)
  dialog:queue("why don't i tell you a story about how i was once a god",true)
  dialog:queue("people would come from miles around and offer me gifts",true)
  dialog:queue("but life seems to have passed me by",true)
  dialog:queue("and now, due to the actions of some 'undesirables', i don't have much time left",true)
  dialog:queue("anyway... ",true) 
  dialog:queue("have fun catching whatever those things are falling from the sky",true) 
  dialog:queue("maybe you'll be able to make some use of them",true) 
-- end

end
-->8
-- update function
function _update60()
 playerbehaviour()
 petals()
 particlelogic()
 moveclouds()
 
 bunnyjump(1)
 bunnyjump(2)
 bunnyjump(3)
 bunnyjump(4)
 
 
 dialog:update()
  

 if (#dialog.dialog_queue == 0) then
  --playdialog=false
  -- restarts cart once dialog is complete
  --_init()
 end

-- play music based on frame number
 frame += 1
 if frame == 1 then
  music(1)
 end 
end
-->8
-- draw function
function _draw()
--clear screen
 rectfill(0,0,128,128,12)
--drawshuttle
-- spr(192,52,88,4,4)
--draw tree
 spr(12,52,88,4,4)
--draw moon
-- spr(196,80,15,4,4)
--draw clouds
 spr(32,cloud1coords[1],cloud1coords[2],4,2)
 spr(52,cloud2coords[1],cloud2coords[2],3,1)
 spr(36,cloud3coords[1],cloud3coords[2],1,1)

--draw bunnies
 spr(bunnies[1].spr,bunnies[1].coords[1],bunnies[1].coords[2],1,2,bunnies[1].flipped)
-- spr(bunnies[2].spr,bunnies[2].coords[1],bunnies[2].coords[2],1,2,bunnies[2].flipped)
-- spr(bunnies[3].spr,bunnies[3].coords[1],bunnies[3].coords[2],1,2,bunnies[3].flipped)
-- spr(bunnies[4].spr,bunnies[4].coords[1],bunnies[4].coords[2],1,2,bunnies[4].flipped)
 
--draw player
 spr(player.spr,player.coords[1],player.coords[2])
--draw bowl 
 spr(bowl.spr,bowl.coords[1],bowl.coords[2]-8)


--talk to bunny
 dialog:draw()
  
--draw ground
 map(0,0,0,118)
--draw score
 print(score,5,5,10)
--draw petals
 for particle in all(particles) do
  pset(particle.x,particle.y,particle.col)
 end 
end
-->8
--player code

function playerbehaviour()
--move player 
 if btn(⬅️) then
  player.at+=1
  player.coords[1]-=player.speed
  bowl.coords[1]-=player.speed
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
  bowl.coords[1]+=player.speed
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
  
--keep player on screen
 if player.coords[1]<0 then
  player.coords[1]=0
  bowl.coords[1]=0
 end
 if player.coords[1]>=128-player.size[1] then
  player.coords[1]=128-player.size[1]
  bowl.coords[1]=128-player.size[1]
 end
  
-- track time since last particle was caught
 tsincelastpart += 1
  
-- make bowl flash 
 if tsincelastpart < 4 then
  bowl.spr=10
 else
  bowl.spr=4
 end
 
 function introtext()
 	dialog:queue("this is test text",true)
  dialog:queue("hello, friend...",true)
  dialog:queue("it's good to see you",true)
  dialog:queue("why don't i tell you a story about how i was once a god",true)
  dialog:queue("people would come from miles around and offer me gifts",true)
  dialog:queue("but life seems to have passed me by",true)
  dialog:queue("and now, due to the actions of some 'undesirables', i don't have much time left",true)
  dialog:queue("anyway... ",true) 
  dialog:queue("have fun catching whatever those things are falling from the sky",true) 
  dialog:queue("maybe you'll be able to make some use of them",true) 
 end

end
-->8
--bunny code
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
  if bunnies[bunny].coords[1]<5 then
   bunnies[bunny].flipped=true
   bunnies[bunny].direction=1
  elseif bunnies[bunny].coords[1]>118 then
   bunnies[bunny].flipped=false
   bunnies[bunny].direction=-1
  end
 end
end

-->8
--dialog code

dialog = {
  x = 16,
  y = 53,
  color = 10,
  max_chars_per_line = 27,
  max_lines = 4,
  dialog_queue = {},
  init = function(self)
  end,
  queue = function(self, message, autoplay)
    -- default autoplay to false
    autoplay = type(autoplay) == "nil" and false or autoplay
    add(self.dialog_queue, {
      message = message,
      autoplay = autoplay
    })

    if (#self.dialog_queue == 1) then
      self:trigger(self.dialog_queue[1].message, self.dialog_queue[1].autoplay)
    end
  end,
  trigger = function(self, message, autoplay)
    self.autoplay = autoplay
    self.current_message = ''
    self.messages_by_line = nil
    self.animation_loop = nil
    self.current_line_in_table = 1
    self.current_line_count = 1
    self.pause_dialog = false
    self:format_message(message)
    self.animation_loop = cocreate(self.animate_text)
  end,
  format_message = function(self, message)
    local total_msg = {}
    local word = ''
    local letter = ''
    local current_line_msg = ''

    for i = 1, #message do
      -- get the current letter add
      letter = sub(message, i, i)

      -- keep track of the current word
      word ..= letter

      -- if it's a space or the end of the message,
      -- determine whether we need to continue the current message
      -- or start it on a new line
      if letter == ' ' or i == #message then
        -- get the potential line length if this word were to be added
        local line_length = #current_line_msg + #word
        -- if this would overflow the dialog width
        if line_length > self.max_chars_per_line then
          -- add our current line to the total message table
          add(total_msg, current_line_msg)
          -- and start a new line with this word
          current_line_msg = word
        else
          -- otherwise, continue adding to the current line
          current_line_msg ..= word
        end

        -- if this is the last letter and it didn't overflow
        -- the dialog width, then go ahead and add it
        if i == #message then
          add(total_msg, current_line_msg)
        end

        -- reset the word since we've written
        -- a full word to the current message
        word = ''
      end
    end

    self.messages_by_line = total_msg
  end,
  animate_text = function(self)
    -- for each line, write it out letter by letter
    -- if we each the max lines, pause the coroutine
    -- wait for input in update before proceeding
    for k, line in pairs(self.messages_by_line) do
      self.current_line_in_table = k
      for i = 1, #line do
        self.current_message ..= sub(line, i, i)

        -- press btn 5 to skip to the end of the current passage
        -- otherwise, print 1 character per frame
        -- with sfx about every 5 frames
        if (not btnp(5)) then
          if (i % 5 == 0) sfx(46)
          yield()
        end
      end
      self.current_message ..= '\n'
      self.current_line_count += 1
      if ((self.current_line_count > self.max_lines) or (self.current_line_in_table == #self.messages_by_line and not self.autoplay)) then
        self.pause_dialog = true
        yield()
      end
    end
    if (self.autoplay) then
    	self.delay(80)
    end
  end,
  shift = function (t)
    local n=#t
    for i = 1, n do
      if i < n then
        t[i] = t[i + 1]
      else
        t[i] = nil
      end
    end
  end,
  -- helper function to add delay in coroutines
  delay = function(frames)
    for i = 1, frames do
      yield()
    end
  end,
  update = function(self)
    if (self.animation_loop and costatus(self.animation_loop) != 'dead') then
      if (not self.pause_dialog) then
        coresume(self.animation_loop, self)
      else
        if btnp(4) then
          self.pause_dialog = false
          self.current_line_count = 1
          self.current_message = ''
        end
      end
    elseif (self.animation_loop and self.current_message) then
      if (self.autoplay) self.current_message = ''
      self.animation_loop = nil
    end

    if (not self.animation_loop and #self.dialog_queue > 0) then
      self.shift(self.dialog_queue, 1)
      if (#self.dialog_queue > 0) then
        self:trigger(self.dialog_queue[1].message, self.dialog_queue[1].autoplay)
        coresume(self.animation_loop, self)
      end
    end

  end,
  draw = function(self)
    local screen_width = 128

    -- display message
    if (self.current_message) then
      print(self.current_message, self.x, self.y, self.color)
    end
  end
}


-->8
--particle code
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
  if particle.y >= player.coords[2]-8
  and particle.y <= player.coords[2]-6
  and particle.x >= player.coords[1]
  and particle.x <= player.coords[1]+7 then
   del (particles,particle)
   score += 1
   sfx(rnd(42))
   tsincelastpart=0
   partfreq=partfreq-0.5
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
-->8
--cloud code

--cloud variables
cloud1coords={-50,25}
cloud2coords={128,30}
cloud3coords={-50,20}

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
00000000003003000030030000300300aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa777777771111222200000000000000000000000000000000
00000000003ff300003ff300003ff300a7aaaaa9aaa7aaaaaaaaaaa9aaaa7aaaaaaaaaaaaaaaaa99777777771111222200000000000000000000000000000000
00700700003ff300003ff300003ff300aaaaaaa90aaaaaaaaaaaaa900aa7aaaaaaaaaaaaaaaaa990777777771177772200000000000000bbbbb0000000000000
00077000003333000033330000333300aaaaaaa900aaaaaaaaaaa90000aaaaaaaaaaaaaaaaaa99007777777711777722000000000000bbbbbbbbb00000000000
000770000033330000333300003333000aaaaa90000aaaaaaaa99000000aaaaaaaaaaaaaaa99900007777770337777990000000000bbbbbbbbbbbbb000000000
007007000099990000999900009999000099990000000999999000000000099999999999999000000077770033777799000000000bbbbfbbbbb3bbbb00000000
000000000090090000f0090000900f0000f00f00000000f00f0000000000000000f00f000000000000f00f003333999900000000bbbbbbbbbbbbbbbbb0000000
0000000000f00f0000000f0000f0000000f00f00000000f00f0000000000000000f00f000000000000f00f00333399990000000bbbbbbbbbbbbbbbbbbb000000
000000000000000000000000444444444445444444444444400000000000000000000000000000000000000000000000000000bbbbb3bbbbbbbbbbbbbbb00000
0000000b00000000000b3000444444444444444444444444400000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbb00000
b3bbbbb3bbbbbbbbbbbbbbbb44444454444444445444444440000000000000000000000000000000000000000000000000000bbbbbbbbbbbb3bbbbbbbbbb0000
333333343b33333b3333333344444444444444444444444540000000000000000000000000000000000000000000000000000bbbbbbbbbbbb33bbbfbbbbb0000
34444444444444434344444444454544444444544444445440000000000000000000000000000000000000000000000000000bbbfbbbbbbbbbbbbbbbbbbb0000
44444445444444444444444444445444444445454444444440000000000000000000000000000000000000000000000000003bbbbbbbbbbbbbbbbbbbbbbb3000
444444444444444445444644444444444444444444444444400000000000000000000000000000000000000000000000000033bbbbbb3bbbbbbbbbbbbbb33000
6444444444444454444444444444444444444444444444444000000000000000000000000000000000000000000000000000333bbbb33bbbbbbbbbbbbb333000
00000000000000000000000000000000000000000000000000077000000000000000000000000000000000000000000000003333bbbbbbbbbbbbbbbbb3333000
00000000000000000000000000000000000000000000000007777700000000000000000000000000000000000000000000000333333bbbbbbbbbbb3333330000
0000000000000000000000000000000000000000000000000777770000000000000000000000000000000000000000000000033333333bbbbbbb333333330000
00000000000000000000000000000000000000000000077077777770000000000000000000000000000000000000000000000033333333333333333333300000
00000000000000000000000000000000007770000007777777777770000000000000000000000000000000000000000000000033333333333333333333300000
00000000077770000000000000000000077777000777776777777760000000000000000000000000000000000000000000000003333333333333333333000000
00000000777777000000000000000000077776600677666677666660000000000000000000000000000000000000000000000000033333044403333300000000
00000000777777700007770000000000666666666666666666666666000000000000000000000000000000000000000000000000000330044400330000000000
00000007777777770077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000044400000000000000
00000077777777770777777770000000000770000000000000000000000000000000000000000000000000000000000000000000000040044400000000000000
00077077777777777777777770770000007777000000000000000000000000000000000000000000000000000000000000000000000304444500000000000000
00777777777777777777777777777000007777700077700000000000000000000000000000000000000000000000000000000000000000045400000000000000
00777777777766777776677777777700077777770777770000777000000000000000000000000000000000000000000000000000000000045400000000000000
00777776666666677666666777777700077777777777777777777700000000000000000000000000000000000000000000000000000000045400000000000000
06766666666666666666666667776660066777777776676777777660000000000000000000000000000000000000000000000000000000444400000000000000
66666666666666666666666666666666666666666666666666666666000000000000000000000000000000000000000000000000000004444440000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040400000404000
00000000000000000000000000000000000000000004040000040400000000000000000000000000000000000000000000000000000000000044440000444400
000000000000000000000000000000000004040000404000004040000004040000000000000000000000000000000000000000000000000000f4f40000e4e400
000000000000000000000000000404000040400004440000044400000040400000040400000000000000000000000000000000000000000000f4f40000e4e400
000000000000000000000000004040000444000014140440444404400444000000404000000404000040400000000000000000000000000000f4f40000e4e400
04040000040040000040400004440000141404404444444414144444444404400044044000404000004040000040400000000000040400000044440000444400
04040000040400000404000014140440444444444444f4444444f444444444440444044404440440004400000404000000000000040400000444444004444440
040404400444044004440440444444444444f4440444f4440444f4441414f4444444444444440444044404400404044000000000040404404444444444444444
0444444414144444141444444444f4440444f444004fff40004fff400444f4441414f44414144444141444440444444400000000044444444414414444144144
1414f4444444f4444444f4440444f444004fff400400004004000040004fff400444ff404444f4444444f4441414f444000000004444f4444444444444444444
4444f4444444f4440444f444004fff4004000040000000040000000400400044004ff0440444ff404444f4404444f444000000004444f4444f4ff4f44e4ff4e4
044fff40044fff40004fff40040000400000004000000000000000000000000000400000004ff044044fff40044fff4000000000044fff404444444444455444
00404440004044400000444000000400000000040000000000000000000000000000000000400000004000040040044000000000004044400444444004444440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0e00000e0e000
0000000000000000000000000000000000000000000e0e00000e0e000000000000000000000000000000000000000000000000000000000000eeee0000eeee00
00000000000000000000000000000000000e0e0000e0e00000e0e000000e0e0000000000000000000000000000000000000000000000000000fefe0000fefe00
000000000000000000000000000e0e0000e0e0000eee00000eee000000e0e000000e0e00000000000000000000000000000000000000000000fefe0000fefe00
00000000000000000000000000e0e0000eee00001e1e0ee0eeee0ee00eee000000e0e000000e0e0000e0e00000000000000000000000000000fefe0000fefe00
0e0e00000e00e00000e0e0000eee00001e1e0ee0eeeeeeee1e1eeeeeeeee0ee000ee0ee000e0e00000e0e00000e0e000000000000e0e000000fefe0000fefe00
0e0e00000e0e00000e0e00001e1e0ee0eeeeeeeeeeeefeeeeeeefeeeeeeeeeee0eee0eee0eee0ee000ee00000e0e0000000000000e0e00000eeeeee00eeeeee0
0e0e0ee00eee0ee00eee0ee0eeeeeeeeeeeefeee0eeefeee0eeefeee1e1efeeeeeeeeeeeeeee0eee0eee0ee00e0e0ee0000000000e0e0ee0eeeeeeeeeeeeeeee
0eeeeeee1e1eeeee1e1eeeeeeeeefeee0eeefeee00efffe000efffe00eeefeee1e1efeee1e1eeeee1e1eeeee0eeeeeee000000000eeeeeeeee1ee1eeee1ee1ee
1e1efeeeeeeefeeeeeeefeee0eeefeee00efffe00e0000e00e0000e000efffe00eeeffe0eeeefeeeeeeefeee1e1efeee00000000eeeefeeeeeeeeeeeeeeeeeee
eeeefeeeeeeefeee0eeefeee00efffe00e0000e00000000e0000000e00e000ee00eff0ee0eeeffe0eeeefee0eeeefeee00000000eeeefeeeefeffefeefeffefe
0eefffe00eefffe000efffe00e0000e0000000e000000000000000000000000000e0000000eff0ee0eefffe00eefffe0000000000eefffe0eeeeeeeeeee55eee
00e0eee000e0eee00000eee000000e000000000e0000000000000000000000000000000000e0000000e0000e00e00ee00000000000e0eee00eeeeee00eeeeee0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000007000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070770000777700
000000000000000000000000000000000007070000070700000707000007070000000000000000000000000000000000000000000000000007e7e70007e7e700
000000000000000000000000000707000070700000707000007070000070700000070700000000000000000000000000000000000000000000e7e70000e7e700
000000000000000000000000007070000777000007770000077700000777000000707000000707000070700000000000000000000000000000e7e70000e7e700
07007000070070000070700007770000878707708787077077770770777707700077077000707000007070000070700000000000070070000077770000777700
07070000070700000707000087870770777777777777777787877777777777770777077707770770007700000707000000000000070700000777777007777770
07070770077707700777077077777777777767777777677777776777878767777777777777770777077707700707077000000000070707707777777777777777
07777777878777778787777777776777077767770777677707776777077767778787677787877777878777770777777700000000077777777787787777877877
87876777777767777777677707776777007666700076667000766670007666700777667077776777777767778787677700000000777767777777777777777777
77776777777767770777677700766670070000700700007007000070007000770076607707776670777767707777677700000000777767777e7ff7e77e7ff7e7
07766670077666700076667007000070000000700000000700000007000000000070000000766077077666700776667000000000077666707777777777755777
00707770007077700000777000000700000000070000000000000000000000000000000000700000007000070070077000000000007077700777777007777770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000009090000090900000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000090900000909000000000000000000000000000000000000000000000000000000000000030300000303000
00000000000000000000000000000000000909000999000009990000000909000000000000000000000000000000000000000000000000000033330000333300
000000000000000000000000000909000090900019910990999909900090900000090900000000000000000000000000000000000000000000e3e30000e3e300
000000000000000000000000009090000999000099999999199199990999000000909000000909000000000000000000000000000000000000e3e30000e3e300
00000000000000000000000009990000199109909999a9999999a9999999099000990990009090000090900000000000000000000000000000e3e30000e3e300
09090000090090000090900019910990999999990999a9990999a999999999990999099909990990009090000090900000000000030300000033330000333300
090900000909000009090000999999999999a999009aaa90009aaa901991a9999999999999990999009900000909000000000000030300000333333003333330
0909099009990990099909909999a9990999a99909000090090000900999a9991991a99919919999099909900909099000000000030303303333333333333333
0999999919919999199199990999a999009aaa900000000900000009009aaa900999aa909999a999199199990999999900000000033333333133331331333313
1991a9999999a9999999a999009aaa9009000090000000000000000000900099009aa0990999aa909999a9991991a999000000003333b3333333333333333333
9999a9999999a9990999a999090000900000009000000000000000000000000000900000009aa0999999a9909999a999000000003333b3333e3ff3e33e3ff3e3
099aaa90099aaa90009aaa9000000900000000090000000000000000000000000000000000900000099aaa90099aaa9000000000033bbb303333333333355333
00909990009099900000999000000000000000000000000000000000000000000000000000000000009000090090099000000000003033300333333003333330
00000000000000000000000000000000000000000000666666660000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000055500000000000000000000000666666666666660000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000576650000000000000000000066666666666666666600000000000000000000000000000000000000000000000000000000000000000000000
00000000000000576650000000000000000000666665566666556666660000000000000000000000000000000000000000000000000000000000000000000000
00000000000005766665000000000000000006666655556666555666666000000000000000000000000000000000000000000000000000000000000000000000
00000000000005766665000000000000000066776665555666675566666600000000000000000000000000000000000000000000000000000000000000000000
00000000000005766665000000000000000667666666555666667565556660000000000000000000000000000000000000000000000000000000000000000000
00000000000005766615000000000000006667666666656666666555555666000000000000000000000000000000000000000000000000000000000000000000
00000000000005766115000000000000006666666666666667666755577666000000000000000000000000000000000000000000000000000000000000000000
00000000000055766665500000000000066666666666666766666666666666600000000000000000000000000000000000000000000000000000000000000000
00000000000575766165650000000000066666666667766666666666656566600000000000000000000000000000000000000000000000000000000000000000
00000000000575766615650000000000066666666666776666556666555656600000000000000000000000000000000000000000000000000000000000000000
00000000005765766165665000000000666666555666677765566666666566660000000000000000000000000000000000000000000000000000000000000000
00000000005765766665665000000000666665566666666765666666666666660000000000000000000000000000000000000000000000000000000000000000
00000000057665766615666500000000666655555556666665566566666666660000000000000000000000000000000000000000000000000000000000000000
00000000057665766165666500000000666655556656666666665656666666660000000000000000000000000000000000000000000000000000000000000000
00000000576665766115666650000000666555556666666666666666666666660000000000000000000000000000000000000000000000000000000000000000
00000000576665766665666650000000666555556655577666666666666666660000000000000000000000000000000000000000000000000000000000000000
00000005766665766665666665000000666755555555557666667766666665660000000000000000000000000000000000000000000000000000000000000000
00000005755665775665675565000000666666655555556666675576566657660000000000000000000000000000000000000000000000000000000000000000
00000057555565755565755556500000066666655555556666755566755576600000000000000000000000000000000000000000000000000000000000000000
00000005555555555555555555000000066665555555556666656666655566600000000000000000000000000000000000000000000000000000000000000000
00000000077777060507777700000000066666666555555666666666666666600000000000000000000000000000000000000000000000000000000000000000
00000000000990066500990000000000006666666666655666666666666666000000000000000000000000000000000000000000000000000000000000000000
00000000000000060500000000000000006666666666655555666666666666000000000000000000000000000000000000000000000000000000000000000000
00000000000000066500000000000000000666666666666666666655566660000000000000000000000000000000000000000000000000000000000000000000
00000000000000060500000000000000000066666666666666666677666600000000000000000000000000000000000000000000000000000000000000000000
00000000000000066500000000000000000006666655666666666576666000000000000000000000000000000000000000000000000000000000000000000000
00000000000000060500000000000000000000666666555566557766660000000000000000000000000000000000000000000000000000000000000000000000
00000000000000066500000000000000000000066666666667777666600000000000000000000000000000000000000000000000000000000000000000000000
00000000000000060500000000000000000000000666666666666660000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000066500000000000000000000000000666666660000000000000000000000000000000000000000000000000000000000000000000000000000
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
01a200000c05500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
01fa00000e05500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
01fa00001005500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00001105500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00001305500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00001505500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00001705500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01fa00001855500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
01ff002009114091150c1140c11510114101150e1140e11509114091150c1140c11510114101150c1140c11509114091150c1140c11510114101150c1140c11509114091150c1140c11510114101150911409115
01ff00001851418515155141551511514115151551415515185141851515514155151151411515105141051518514185151551415515115141151515514155151851418515155141551511514115151051410515
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000235151f5252251520525215052350521505235051f505225051e505235052050523505245052250523505215052150523505235052350521505215052250521505215052250524505215052250523505
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200002063418634006041c6241362400604186540f654006040060400604006040060400604006040060400604006040060400604006040060400604006040060400604006040060400604006040060400604
01100000185110e551255510050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501005010050100501
__music__
02 2a424344
00 2b424344

