# SEMINARSKA RABOTA PO BIZNIS STATISTIKA
# Stefan Vezenkoski 233152
#__________________________________________________________________________________
# RABOTAM SO PODATOCNO MNOZESTVO KADE SE PRIKAZUVAAT PODATOCI ZA PACIENTI KOI IMAAT GLAUKOM. VO EXCEL TABELATA SE VKLUCENI SLEDNIVE OBELEZJA: 
#- RL
#- glaucoma: 1 dokolku ima, 0 dokolku nema
#- age
#- ocular_pressure
#- MD
#- PSD: promenlivost na standardot na defektot
#- GHT
#- cornea_thickness: debelina na roznica
#- RNFL4.mean

#JAS RABOTAM SO SLEDNIVE DVE OBELEZJA:
#  - PSD
#  - cornea_thickness
#_____________________________________________________________________________________

# kodot pocnuva tuka

install.packages("ggplot2", dependencies = FALSE)
install.packages("readr", dependencies = FALSE)
install.packages("dplyr", dependencies = FALSE)
install.packages("data.table", dependencies = FALSE)
install.packages("readxl", dependencies = FALSE)

library(readr)
library(ggplot2)
library(dplyr)
library(data.table)
library(readxl)

# Поставување на работната папка------------------------------------------
setwd("C:/Users/User1/Desktop/")

# Читање на целосната CSV датотека---------------------------------------
податоци <- read_csv("ds_whole.csv")

# Притсап до обележјата PSD и cornea_thickness-------------------------------
PSD_values <- податоци$PSD
cornea_thickness_values <- податоци$cornea_thickness

# Функција за создавање на хистограм и полигон
create_hist_and_polygon <- function(values, variable_name, color_hist, color_polygon) {
  num_intervals <- round(sqrt(length(values)))
  range_values <- max(values) - min(values)
  width <- range_values / num_intervals

  # Хистограм
  hist_data <- hist(values, breaks = num_intervals, plot = FALSE)

  # Создавање на хистограм
  hist_plot <- ggplot(data = data.frame(x = values), aes(x = x)) +
    geom_histogram(binwidth = width, fill = color_hist, color = "black") +
    labs(x = paste(variable_name, "Вредности"), y = "Фреквенција", title = paste("Хистограм на", variable_name)) +
    theme_minimal()

  # Подготовка на податоци за полигон
  x.axis <- c(min(hist_data$breaks), hist_data$mids, max(hist_data$breaks))
  y.axis <- c(0, hist_data$counts, 0)

  # Создавање на полигон
  polygon_plot <- ggplot() +
    geom_polygon(aes(x = x.axis, y = y.axis), fill = color_polygon, alpha = 0.5) +
    labs(x = paste(variable_name, "Вредности"), y = "Густина", title = paste("Густински полигон на", variable_name)) +
    theme_minimal()

  return(list(hist_plot = hist_plot, polygon_plot = polygon_plot))
}

#____PRV DEL______________________________________________________________________________

# За обележјето PSD:--------------------------------------------------
# Пресметка на бројот на интервали
num_intervals_PSD <- round(sqrt(length(PSD_values)))

# Пресметка на ширината на интервалите за PSD
range_PSD <- max(PSD_values) - min(PSD_values)
width_PSD <- range_PSD / num_intervals_PSD

# Пресметка на интервалите и табела со распределба на честоти за PSD
intervals_PSD <- seq(min(PSD_values), max(PSD_values), by = width_PSD)
freq_table_PSD <- cut(PSD_values, breaks = intervals_PSD, right = FALSE, include.lowest = TRUE)
freq_table_PSD <- table(freq_table_PSD)

# Пресметка на средни точки на интервалите
midpoints_PSD <- (intervals_PSD[-length(intervals_PSD)] + intervals_PSD[-1]) / 2

# Пресметка на релативни и кумулативни фреквенции
rel_freq_PSD <- prop.table(freq_table_PSD)
cum_freq_PSD <- cumsum(freq_table_PSD)

# Пресметка на релативни и кумулативни фреквенции во проценти
rel_freq_percent_PSD <- rel_freq_PSD * 100
cum_freq_percent_PSD <- cum_freq_PSD / sum(freq_table_PSD) * 100

# Креирање на табелата со распределба на честоти за PSD
freq_table_df_PSD <- data.frame(
  Интервали = names(freq_table_PSD),
  Средни_точки = midpoints_PSD,
  Фреквенција = as.numeric(freq_table_PSD),
  Релативна_фреквенција = as.numeric(rel_freq_PSD),
  Релативна_фреквенција_проценти = as.numeric(rel_freq_percent_PSD),
  Кумулативна_фреквенција = as.numeric(cum_freq_PSD),
  Кумулативна_фреквенција_проценти = as.numeric(cum_freq_percent_PSD)
)

# Печатење на табелата со распределба на честоти за PSD
cat("Табела со распределба на честоти за PSD:\n")
print(freq_table_df_PSD)

# Создавање на хистограм и полигон за PSD
PSD_plots <- create_hist_and_polygon(PSD_values, "PSD", "lightblue", "lightblue")

# Печатење на графиките за PSD
print(PSD_plots$hist_plot)
print(PSD_plots$polygon_plot)

#__________________________________________________________________________________________

# За обележјето cornea_thickness:---------------------------------------

# Пресметка на бројот на интервали
num_intervals_cornea <- round(sqrt(length(cornea_thickness_values)))

# Пресметка на ширината на интервалите за cornea_thickness
range_cornea <- max(cornea_thickness_values) - min(cornea_thickness_values)
width_cornea <- range_cornea / num_intervals_cornea

# Пресметка на интервалите и табела со распределба на честоти за cornea_thickness
intervals_cornea <- seq(min(cornea_thickness_values), max(cornea_thickness_values), by = width_cornea)
freq_table_cornea <- cut(cornea_thickness_values, breaks = intervals_cornea, right = FALSE, include.lowest = TRUE)
freq_table_cornea <- table(freq_table_cornea)

# Пресметка на средни точки на интервалите
midpoints_cornea <- (intervals_cornea[-length(intervals_cornea)] + intervals_cornea[-1]) / 2

# Пресметка на релативни и кумулативни фреквенции
rel_freq_cornea <- prop.table(freq_table_cornea)
cum_freq_cornea <- cumsum(freq_table_cornea)

# Пресметка на релативни и кумулативни фреквенции во проценти
rel_freq_percent_cornea <- rel_freq_cornea * 100
cum_freq_percent_cornea <- cum_freq_cornea / sum(freq_table_cornea) * 100

# Креирање на табелата со распределба на честоти за cornea_thickness
freq_table_df_cornea <- data.frame(
  Интервали = names(freq_table_cornea),
  Средни_точки = midpoints_cornea,
  Фреквенција = as.numeric(freq_table_cornea),
  Релативна_фреквенција = as.numeric(rel_freq_cornea),
  Релативна_фреквенција_проценти = as.numeric(rel_freq_percent_cornea),
  Кумулативна_фреквенција = as.numeric(cum_freq_cornea),
  Кумулативна_фреквенција_проценти = as.numeric(cum_freq_percent_cornea)
)

# Печатење на табелата со распределба на честоти за cornea_thickness
cat("\nТабела со распределба на честоти за cornea_thickness:\n")
print(freq_table_df_cornea)

# Создавање на хистограм и полигон за cornea_thickness
cornea_plots <- create_hist_and_polygon(cornea_thickness_values, "Cornea Thickness", "lightgreen", "lightgreen")

# Печатење на графиките за cornea_thickness
print(cornea_plots$hist_plot)
print(cornea_plots$polygon_plot)


# Прикажување на сите графики во мрежа
library(gridExtra)
grid.arrange(PSD_plots$hist_plot, PSD_plots$polygon_plot, cornea_plots$hist_plot, cornea_plots$polygon_plot, ncol = 2, nrow = 2)

# _______________________________________________________________________________________


# _______________________________________________________________________________________
# Стебло-лист дијаграм за PSD --------------------------------------------------------
myStem <- function(x, leftDigits, rounding = 1) {
  data = data.table("x" = x)
  data[, left := floor(x / 10^leftDigits)]
  data[, right := (round(x - left * 10^leftDigits, rounding)) * 10^rounding]
  data = data[, paste(sort(right), collapse = " "), by = left]
  data[, out := paste(left, " | ", V1), by = left]
  cat(data$out, sep = "\n")
}

cat("\nСтебло-лист дијаграм за PSD:\n")
myStem(PSD_values, 0, 2)
#_________________________________________________________________________________________


#_________________________________________________________________________________________
# 2. Графика на расејување за двете обележја--------------------------------
scatter_plot <- ggplot(податоци, aes(x = PSD_values, y = cornea_thickness_values)) +
  geom_point() +
  labs(x = "PSD Values", y = "Cornea Thickness Values", title = "Scatter Plot of PSD vs Cornea Thickness") +
  theme_minimal()

# --------------------------------------------------------------------------------
# ДИСКУТИРАЊЕ ЗА ГРАФИКОТ НА РАСЕЈУВАЊЕ:
# Од графикот може да се забележи дека постои негативна линеарна корелација помеѓу двете обележја. Коефициентот на корелација r е -0.1501, што укажува на слаба негативна корелација помеѓу двете обележја.
# --------------------------------------------------------------------------------


print(scatter_plot)


#_____________________________________________________________________________________

# 3. Мода, медијана и просек за cornea_thickness -------------------------------------

cornea_mode <- as.numeric(names(table(cornea_thickness_values))[which.max(table(cornea_thickness_values))])
cornea_median <- median(cornea_thickness_values)
cornea_mean <- mean(cornea_thickness_values)

cat("\nМода, медијана и просек за корnea_thickness:\n")
print(paste("Мода:", cornea_mode))
print(paste("Медијана:", cornea_median))
print(paste("Просек:", cornea_mean))

# 4. Квартали, опсег и интерквартален распон за корнеалната дебелина---------
cornea_quantiles <- quantile(cornea_thickness_values, probs = c(0.25, 0.5, 0.75))
cornea_range <-  max(cornea_thickness_values) - min(cornea_thickness_values)
cornea_IQR <- IQR(cornea_thickness_values)

cat("\nКвартили, опсег и интерквартален распон за cornea_thickness:\n")
print("Квартили:")
print(cornea_quantiles)
print("Опсег:")
print(cornea_range)
print("Интерквартален распон:")
print(cornea_IQR)

# 5. Пресметка на дисперзија и стандардна девијација----------------------
cornea_variance <- var(cornea_thickness_values)
cornea_sd <- sd(cornea_thickness_values)

cat("\nДисперзија и стандардна девијација за cornea_thickness:\n")
print(paste("Дисперзија:", cornea_variance))
print(paste("Стандардна девијација:", cornea_sd))
#_____________________________________________________________________________________



#_______________________________________________________________________________________
# 6. Пресметка на мода, медијана, просек, IQR и квартили за PSD-----------------------
PSD_mode <- as.numeric(names(table(PSD_values))[which.max(table(PSD_values))])
PSD_median <- median(PSD_values)
PSD_mean <- mean(PSD_values)
PSD_IQR <- IQR(PSD_values)
PSD_range <- max(PSD_values) - min(PSD_values)
PSD_quartiles <- quantile(PSD_values, probs = c(0.25, 0.5, 0.75))


cat("\nМода, медијана, просек, интерквартален распон и квартили за PSD:\n")
print(paste("Мода:", PSD_mode))
print(paste("Медијана:", PSD_median))
print(paste("Просек:", PSD_mean))
print(paste("Интерквартален распон:", PSD_IQR))
print("Опсег:")
print(PSD_range)
print("Kвартили: ")
print(PSD_quartiles)

# Пресметка на дисперзија и стандардна девијација----------------------
PSD <- var(PSD_values)
PSD_sd <- sd(PSD_values)

cat("\nДисперзија и стандардна девијација за PSD:\n")
print(paste("Дисперзија:", PSD))
print(paste("Стандардна девијација:", PSD_sd))
#______________________________________________________________________________________



#_________________________________________________________________________________
# 7. Пресметка на коефициент на корелација за PSD и cornea_thickness------
correlation_coefficient <- cor(PSD_values, cornea_thickness_values)

cat("\nКоефициент на корелација помеѓу PSD и cornea_thickness:\n")
print(correlation_coefficient)
#______________________________________________________________________________________

print("----------------------------------------------------------------------------------------------------")




#____VTOR DEL______________________________________________________________________________
print("----------------------------------------------------------------------------------------------------")

# VTOR DEL, zadaca 1 ------------------------------------------------------------------------
# interval na doverba-----------------------------------
interval_doverba <- function(volume) {
  CI <- 0.95  # INTERVAL NA SIGURNOST(%) od 95%
  alfa <- 1 - CI  # nivoto na prifatliva greshka(%)
  MoE <- qnorm(1 - alfa / 2) * sd(volume) / sqrt(length(volume))
  min.interval <- mean(volume) - MoE
  max.interval <- mean(volume) + MoE
  
  # pecati interval
  print(c(min.interval, max.interval))
  print(mean(volume))
}

sample_size <- min(1000, length(PSD_values))
interval_doverba(sample(PSD_values, size = sample_size))
print("----------------------------------------------------------------------------------------------------")

# VTOR DEL, zadaca 2 ------------------------------------------------------------------------
# hipotezi-----------------------------------
# H0: EX = 5
# Ha: EX != 5
EX <- 5
alfa <- 0.05
gr <- qnorm(1 - alfa / 2) # se naogja granicata
print("Интервал на доверба:")
print(c(-1 * gr, gr)) # se pecati intervalot (leva i desna granica)
z <- ((mean(PSD_values) - EX) / sd(PSD_values)) * sqrt(length(PSD_values)) # determinantna vrednost vo intervalot
print(z)

# proverka koja hipoteza e tocna
if(z > (-1 * gr) & z < gr) {
  print("H0: T. H0 се прифаќа")
} else {
  print("Ha: T. H0 се отфрла")
}
print("----------------------------------------------------------------------------------------------------")
# -------------------------------------------------------------------------------------------

# VTOR DEL, zadaca 3 ------------------------------------------------------------------------
# test za raspredelba------------------------
# Тестирање на нормалност за PSD
print("Непараметарски тест(тест за распределба):")
print("H0: Обележјето PSD има нормална распределба.")
print("H0: Обележјето PSD нема нормална распределба.")

# Тестирање на нормалност за PSD
shapiro_test_PSD <- shapiro.test(PSD_values)
cat("\nРезултати од Шапиро-Вилковиот тест за нормалност за PSD:\n")
print(shapiro_test_PSD)

# Објаснување
if (shapiro_test_PSD$p.value < 0.05) {
  cat("Нултата хипотеза (H0) се отфрла: Обележјето PSD нема нормална распределба.\n")
} else {
  cat("Нултата хипотеза (H0) не се отфрла: Обележјето PSD има нормална распределба.\n")
}


print("----------------------------------------------------------------------------------------------------")

# -------------------------------------------------------------------------------------------

# VTOR DEL, zadaca 4 ------------------------------------------------------------------------
# test na hipotezi za nezavisnost------------
if ("вашата_колона_1" %in% colnames(податоци) && "вашата_колона_2" %in% colnames(податоци)) {
  chisq_test <- chisq.test(table(податоци$вашата_колона_1, податоци$вашата_колона_2))
  print(chisq_test)
} else {
  cat("Chi-squared тестот не е применлив.\n")
}

# print("----------------------------------------------------------------------------------------------------")


# VTOR DEL, zadaca 5 ------------------------------------------------------------------------
# linearna regresija-------------------------
plot(PSD_values, cornea_thickness_values) 

# создавање на модел за линерна регресија
model <- lm(cornea_thickness ~ PSD, data = податоци) 
abline(model, col='red') # цртање на линија на регресија

r <- cor(податоци$PSD, податоци$cornea_thickness)
print(r)

# мануелно да се внесе X и со моделот да се предвиди вредноста на Y
pred <- predict(model, newdata = data.frame(PSD = 15), level = 0.95, interval = "prediction")
print(pred)

# -------------------------------------------------------------------------------------------


# Функција за создавање на хистограм и полигон
create_hist_and_polygon <- function(values, variable_name, color_hist, color_polygon) {
  num_intervals <- round(sqrt(length(values)))
  range_values <- max(values) - min(values)
  width <- range_values / num_intervals

  # Хистограм
  hist_data <- hist(values, breaks = num_intervals, plot = FALSE)

  # Создавање на хистограм
  hist_plot <- ggplot(data = data.frame(x = values), aes(x = x)) +
    geom_histogram(binwidth = width, fill = color_hist, color = "black") +
    labs(x = paste(variable_name, "Вредности"), y = "Фреквенција", title = paste("Хистограм на", variable_name)) +
    theme_minimal()

  # Подготовка на податоци за полигон
  x.axis <- c(min(hist_data$breaks), hist_data$mids, max(hist_data$breaks))
  y.axis <- c(0, hist_data$counts, 0)

  # Создавање на полигон
  polygon_plot <- ggplot() +
    geom_polygon(aes(x = x.axis, y = y.axis), fill = color_polygon, alpha = 0.5) +
    labs(x = paste(variable_name, "Вредности"), y = "Густина", title = paste("Густински полигон на", variable_name)) +
    theme_minimal()

  return(list(hist_plot = hist_plot, polygon_plot = polygon_plot))
}





# Прикажување на сите графики во мрежа
library(gridExtra)
grid.arrange(PSD_plots$hist_plot, PSD_plots$polygon_plot, cornea_plots$hist_plot, cornea_plots$polygon_plot, ncol = 2, nrow = 2)

#__________________________________________________________________________________________