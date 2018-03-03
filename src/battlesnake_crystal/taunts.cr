module Taunts
  extend self

  def next(json : String)
    api = BattlesnakeAPI.from_json(json)
    return "" if previous_taunt(api).empty? 

    "#{previous_taunt(api).lchop}#{previous_taunt(api).char_at(0)}"
  end

  def previous_taunt(api)
    taunt = api.you.taunt

    if taunt.nil?
      ""
    else
      taunt
    end
  end
end
