package main

import "fmt"

// Lỗi: Hàm có Cyclomatic Complexity cao (> 10) và IF lồng sâu
func ComplexFunction(a, b, c, d, e int) string {
	if a > 0 {
		if b > 0 {
			if c > 0 {
				if d > 0 {
					if e > 0 {
						return "Lồng quá 5 tầng IF"
					}
				}
			}
		}
	}

	// Cố tình tạo nhiều nhánh điều kiện để tăng Cyclomatic Complexity
	switch a {
	case 1: fmt.Println("One")
	case 2: fmt.Println("Two")
	case 3: fmt.Println("Three")
	case 4: fmt.Println("Four")
	case 5: fmt.Println("Five")
	}

	return "Done"
}

func main() {
	ComplexFunction(1, 2, 3, 4, 5)
}