rednet.open("top")
while true do
    local id, message = rednet.receive()
    print(id,message)
end