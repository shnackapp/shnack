class ItemController < ApplicationController

  def has_mod?
    if item.has_instance_of?(Modifier)
      true
    else
      false
  end

end
