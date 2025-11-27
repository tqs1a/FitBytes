package com.fitnesstracker.ui.activity

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ActivityFeedScreen() {
    var selectedPeriod by remember { mutableStateOf(TimePeriod.TODAY) }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Activity") },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.surface,
                    titleContentColor = MaterialTheme.colorScheme.onSurface
                )
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            // Period Selector
            PeriodSelector(
                selectedPeriod = selectedPeriod,
                onPeriodSelected = { selectedPeriod = it }
            )
            
            // AI Overview Card
            AIOverviewCard(period = selectedPeriod)
            
            // Activity Feed
            Text(
                text = "Activities",
                style = MaterialTheme.typography.titleLarge,
                color = MaterialTheme.colorScheme.onSurface
            )
            
            // Activity items would go here
            Text(
                text = "Activity feed items will appear here",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.7f)
            )
        }
    }
}

enum class TimePeriod {
    TODAY, WEEK
}

@Composable
fun PeriodSelector(
    selectedPeriod: TimePeriod,
    onPeriodSelected: (TimePeriod) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        TimePeriod.values().forEach { period ->
            FilterChip(
                selected = selectedPeriod == period,
                onClick = { onPeriodSelected(period) },
                label = { Text(period.name) },
                modifier = Modifier.weight(1f)
            )
        }
    }
}

@Composable
fun AIOverviewCard(period: TimePeriod) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            Text(
                text = "AI Overview",
                style = MaterialTheme.typography.titleLarge,
                color = MaterialTheme.colorScheme.onSurface
            )
            Text(
                text = if (period == TimePeriod.TODAY) {
                    "Today you've already taken 8,420 steps and burned 1,850 calories. You're on track to reach your daily goal!"
                } else {
                    "This week was very active! You averaged 9,200 steps per day and completed 5 workouts. Your progress is impressive!"
                },
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.8f)
            )
        }
    }
}

