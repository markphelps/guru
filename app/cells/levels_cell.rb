class LevelsCell < Cell::Rails
  def top(studio)
    @levels = studio.levels.top_ten
    render
  end
end
