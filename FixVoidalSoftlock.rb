begin
  missing = ['0000.injection.rb'].select { |f| !File.exist?(File.join(__dir__, f)) }
  raise "Dependency #{missing[0]} is required by #{__FILE__}. Please install it." if missing.length == 1
  raise "Dependencies #{missing.join(", ")} are required by #{__FILE__}. Please install them." if missing.length > 1
end

InjectionHelper.defineMapPatch(520, 57) { |event| # Voidal Chasm, warp at (039,047)
  for page in event.pages
    if page.condition.variable_valid && page.condition.variable_id == 767 # The offending variable
      page.condition.variable_valid = false
    end
  end
}
