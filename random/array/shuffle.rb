class Array
  def shuffle
    sort_by { Kernel.rand }
  end

  def shuffle!
    self.replace shuffle
  end
end
