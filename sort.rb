def merge(arr1, arr2)
  if arr1.empty?
    arr2
  elsif arr2.empty?
    arr1
  elsif arr1.first < arr2.first
    [ arr1.shift  ]+ merge(arr1, arr2)
  else
    [ arr2.shift ] + merge(arr1, arr2)
  end
end

def sort(arr)
  if arr.length == 1
    return arr
  end
  half = arr.length  / 2
  merge(sort(arr.slice(0,half)), sort(arr.slice(half,arr.length)))
end

puts sort([2,4,5,9, 1,3,5,6,8,10])
