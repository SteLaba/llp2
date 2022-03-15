section .text

%include 'colon.inc'

extern find_word
extern read_word
extern print_string
extern print_error
extern print_newline
extern string_length
extern exit
global _start

section .data

%include 'words.inc'

input_request: db 'Enter the word: ', 0
found: db 'Entry found: ', 0
missing: db 'No entries found.', 0
error: db 'ERROR! Word cannot be read!', 0

section .text

_start:
	mov rdi, input_request		;загружаем в rdi строку 'Enter the word: '
	call print_string		;выводим строку которая в rdi
	sub rsp, 256			;в стеке аллоцируем буффер длины 256 байт 
	mov rsi, 256			;длина буфера в rsi
	mov rdi, rsp			;вершина стека в rdi
	call read_word 			;читаем ключ - слово
	test rax, rax 			;проверяем значение в rax, если равно нулю то не удалось
 	jz .bad_read 			;прочитать слово, переход на обработку ошибки
	mov rsi, begin			;загружаем в rsi первый элемент нашего списка
	mov rdi, rax 			;в rdi загружаем прочитанное ключ - слово
	call find_word			;вызываем функцию нахождения слова в словаре
	test rax, rax 			;проверяем значение в rax, если равно нулю то не нашли
	je .none_found 			;слово в словаре, переход на обработку не найденого слова
					;обработка найденого слова
	add rax, 8			;увеличиваем rax на величину нашего ключа
	push rax			;сохраняем rax, чтобы потом его вывести
	mov rdi, found			;загружаем в rdi строку 'Entry found: '
	call print_string 		;выводим строку
	pop rdi 			;возвращаем значение найденого слова
	call string_length		;находим длину строки
	inc rax				;увеличиваем на 1, из-за нуль-терминатора
	add rdi, rax			;пропускаем макром определенное обяснение
	call print_string		;выводим значение(обяснение найденого слова)
	jmp .end			

.bad_read:
	mov rdi, error			;загружаем в rdi строку 'ERROR! Word cannot be read!'
	call print_error		;выводим ошибку
	jmp .end			

.none_found:
	mov rdi, missing		;загружаем в rdi строку 'No entries found.'
	call print_string		;выводим строку
.end:
	call print_newline		
	add rsp, 256			;воостанавливаем наш стек
	call exit  
