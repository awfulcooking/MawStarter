Maw!

controls.define :quit, keyboard: :q, controller_one: [:start], mouse: :button_middle
controls.define :reset, keyboard: :r, controller_one: :r1

controls.define :framerate, keyboard: :t, controller_one: :x

controls.define :left, keyboard: :a, controller_one: :left
controls.define :right, keyboard: :d, controller_one: :right

controls.define :boost, keyboard: :shift, controller_one: [:l2, :r2]

DDX_NORMAL = 0.92
DDX_BOOST = 0.97

init {
  play_sound_effect

  $state.background = [ rand(255), rand(255), rand(255) ]

  $state.player = {
    r: 255, g: 105, b: 199,
    x: 500, y: 50, w: 280, h: 10,

    dx: (3+rand(15)).rand_sign,
    ddx: DDX_NORMAL,
  }
}

tick {
  init if controls.reset_down?
  exit if controls.quit?

  background! $state.background

  movement
  bounds

  solids << $state.player

  if controls.framerate_latch?
    primitives << $gtk.framerate_diagnostics_primitives
  end
}

def movement
  if controls.left?
    $state.player.dx -= 4
  elsif controls.right?
    $state.player.dx += 4
  end

  $state.player.ddx = controls.boost? ? DDX_BOOST : DDX_NORMAL

  $state.player.x += $state.player.dx
  $state.player.dx *= $state.player.ddx
end

def bounds
  if $state.player.x < (0-$state.player.w)
    $state.player.x = grid.w
  elsif $state.player.x > grid.w
    $state.player.x = 0-$state.player.w
  end
end

def play_sound_effect
  audio[:sound_effect] = {
    input: 'sounds/GameStart.wav'
  }
end
