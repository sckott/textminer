def singlearray2hash(x)
  if x.length == 1 && x.class == Array
    return x[0]
  else
    return x
  end
end
