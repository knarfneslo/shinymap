app <- ShinyDriver$new("../")


app$snapshotInit("mytest")

app$setInputs()
app$snapshot()
app$setInputs(level2 = "Spirometri hos fastlege (andeler)")
app$snapshot()
app$setInputs(level1 = "Poliklinikk")
app$snapshot()
app$setInputs(level1 = "Akuttinnleggelser")
app$setInputs(level2 = "Reinnleggelser")
app$snapshot()
app$setInputs(level1 = "Sykelighet")
app$snapshot()
