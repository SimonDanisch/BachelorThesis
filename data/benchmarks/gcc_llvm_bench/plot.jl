using DataFrames, ExcelReaders, YTables

LLVM35vs36 = readxl(DataFrame, "Desktop\\llvm5vs6.xlsx", "sheet1!A1:D35", colnames=[:Benchmark, :LLVM35, :LLVM36, :LLVM_Better])
GCCvsLLVM = readxl(DataFrame, "Desktop\\GCCvsLLVM.xlsx", "sheet1!A1:D32", colnames=[:Benchmark, :GCC492, :LLVM35, :LLVM_Better])

# handle if bigger is better or smaller is better
diff = zeros(Float64, length(LLVM35vs36[:LLVM35]))
for i=1:length(LLVM35vs36[:LLVM35])
	l5, l6, w = LLVM35vs36[:LLVM35][i], LLVM35vs36[:LLVM36][i], LLVM35vs36[:LLVM_Better][i]
	if sign(l5 - l6) == sign(w) # bigger is better
		dim = l5
		nom = l6
	else
		dim = l6
		nom = l5
	end
	diff[i] = dim/nom
end
LLVM35vs36[:Difference] = diff


diff = zeros(Float64, length(GCCvsLLVM[:GCC492]))
for i=1:length(GCCvsLLVM[:GCC492])
	l5, l6, w = GCCvsLLVM[:GCC492][i], GCCvsLLVM[:LLVM35][i], GCCvsLLVM[:LLVM_Better][i]
	if sign(l5 - l6) == sign(w) # bigger is better
		dim = l5
		nom = l6
	else
		dim = l6
		nom = l5
	end
	diff[i] = dim/nom
end
GCCvsLLVM[:Difference] = diff

summary = DataFrame(
Method = ["mean", "median", "maximum", "minimum"],
GCCvsLLVM = [(mean(GCCvsLLVM[:Difference])), 
(median(GCCvsLLVM[:Difference])), 
(maximum(GCCvsLLVM[:Difference])), 
(minimum(GCCvsLLVM[:Difference]))],

LLVM35vs36 = [(mean(LLVM35vs36[:Difference])),
(median(LLVM35vs36[:Difference])),
(maximum(LLVM35vs36[:Difference])),
(minimum(LLVM35vs36[:Difference]))]
)

delete!(GCCvsLLVM, :LLVM_Better)
delete!(LLVM35vs36, :LLVM_Better)

latex(LLVM35vs36)
latex(GCCvsLLVM)
println(latex(summary))