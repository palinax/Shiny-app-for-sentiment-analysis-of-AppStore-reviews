#downloaded from http://www2.imm.dtu.dk/pubdb/pubs/6010-full.html
newfinn <- data.table(read.table("data-raw/AFINN-111.txt", sep = "\t", quote = ""))
setnames(newfinn, names(newfinn), c("word", "value"))
usethis::use_data(newfinn, overwrite = T)
