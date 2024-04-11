df <- read_dta('C:/Projects/smwap_project/data/data_final.dta')

create_dist_matrix <- function() {
  N <-  nrow(df)
  distance <- matrix(0, nrow = N, ncol = N)
  for(ii in 1:N) {
    for(jj in 1:N) {
      temp_agg = rep(0, 19)
      for (kk in 2:20) {
        temp_agg[kk-1] <- abs(df[[kk]][ii] - df[[kk]][jj])
      }
      distance[ii, jj] <- sum(temp_agg, na.rm = TRUE)
    }
  }
  #distance <- 1/distance
  #diag(distance) <- 0
  #distance <- distance / (as.matrix(rowSums(distance)) %*% matrix(1, nrow = 1, ncol = N))
  return(distance)
}
create_cluster_plot <- function(group_var) {
  inside_dist <- rep(0, 196)
  outside_dist <- rep(0, 196)
  for (i in 1:196) {
    same_objects_indeces <- which(df[[group_var]] == df[[group_var]][i])          # do wewnatrzgrupowe odleglosci
    different_objects_indeces <- which(df[[group_var]] != df[[group_var]][i])     # do zewnatrzgrupowych odleglosci
    inside_dist[i] <- mean(distance[i, same_objects_indeces], na.rm = TRUE)
    outside_dist[i] <- 1/mean(distance[i, different_objects_indeces], na.rm = TRUE)
  }
  df[[paste0(group_var, '_in_dist')]] <- inside_dist
  df[[paste0(group_var, '_out_dist')]] <- outside_dist
  
  
  plot_ly(
    x = df[[paste0(group_var, '_in_dist')]],
    y = df[[paste0(group_var, '_out_dist')]],
    color = paste0('grupa ', df[[group_var]]),
    type = 'scatter',
    mode = 'markers',
    text = df$stock_id,
    visible = FALSE
  ) %>% 
    add_text(
      x = df[[paste0(group_var, '_in_dist')]],
      y = df[[paste0(group_var, '_out_dist')]],
      text = df$stock_id,
      #showlegend = FALSE,
      visible = TRUE
    ) %>% 
    layout(
      xaxis = list(title = 'Dystans wewnątrzgrupowy'),
      yaxis = list(title = '1/Dystans zewnątrzgrupowy'),
      title = group_var
    )
}
distance <- create_dist_matrix()
#distance




group_var <- colnames(df)[32]
create_cluster_plot(group_var)
