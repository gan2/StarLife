module StarLife
  StarRuby::Input.instance_eval do
    # 1 フレーム分しか押せないようにした keys のラッパー
    def triggers(device)
      # duration はキーが押されてから押されていると判断される持続時間 (フレーム数)
      # この場合、押しっぱなしにしても 1 フレーム分しか押してないのと同じことになる
      keys(device, :duration => 1)
    end
    
    def repeatings(device)
      # delay    は 2 回目以降「押された」と判別されるまでの遅延時間 (フレーム数)
      # interval は 2 回目以降「押された」と判断される時間間隔 (フレーム数)
      # 2 回目の「押された」が判断されるのは 1 回目から delay フレーム後で
      # その後 3 回目以降の「押された」が判断されるまでにかかるのは interval フレーム
      keys(device, {
          :duration => 1, :delay => 2, :interval => 0
        })
    end
  end
  
  class Controller
    def update(model)
      send("update_#{model.state}", model)
    end

    def update_start(model)
      if Input.keys(:keyboard).size > 0 or Input.keys(:mouse).size > 0
        model.start_playing
      end
    end

    def update_playing(model)
      if Input.triggers(:keyboard).include?(:p)
        model.pause
      elsif Input.triggers(:keyboard).include?(:r)
        model.init
      elsif Input.repeatings(:keyboard).include?(:j)
        model.shorten_interval
      elsif Input.repeatings(:keyboard).include?(:k)
        model.extend_interval
      elsif Input.triggers(:keyboard).include?(:t)
        model.toggle_debug_mode
      elsif Input.keys(:mouse).include?(:left)
        model.click
      else
        model.go_next_generation
      end
    end

    def update_pause(model)
      if Input.triggers(:keyboard).size > 0
        model.resume
      end
    end
  end
end
