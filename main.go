package main

import "fmt"

func ComplexFunction(a, b, c, d, e, f, g int) string {
	// ❌ Nestif: Lồng 6 tầng IF (vượt xa ngưỡng 3)
	if a > 0 {
		a++
		if b > 0 {
			b++
			if c > 0 {
				c++
				if d > 0 {
					d++
					if e > 0 {
						e++
						if f > 0 {
							f++
							if g > 0 {
								return "Lồng quá 6 tầng IF"
							}
						}
					}
				}
			}
		}
	}

	// ❌ Cyclomatic complexity > 15
	if a == 1 || b == 2 || c == 3 || d == 4 || e == 5 {
		fmt.Println("Branch 1")
	} else if a == 6 || b == 7 || c == 8 || d == 9 {
		fmt.Println("Branch 2")
	}

	switch a {
	case 1: fmt.Println("One")
	case 2: fmt.Println("Two")
	case 3: fmt.Println("Three")
	case 4: fmt.Println("Four")
	case 5: fmt.Println("Five")
	case 6: fmt.Println("Six")
	case 7: fmt.Println("Seven")
	}

	return "Done"
}

func main() {
	ComplexFunction(1, 2, 3, 4, 5, 6, 7)
}